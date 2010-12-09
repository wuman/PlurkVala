using Json;

public class Roguso.ResponseList : GLib.Object {

    private static const string KEY_RESPONSES = "responses";
    private static const string KEY_FRIENDS = "friends";
    private static const string KEY_RESPONSE_COUNT = "response_count";
    private static const string KEY_RESPONSES_SEEN = "responses_seen";

    private HashTable<string, Response> response_by_id = new HashTable<string, Response>(GLib.str_hash, GLib.str_equal);
    private List<Response> response_list = new List<Response>();

    public int64 responses_seen { get; set; default = 0; }
    public int64 response_count { get; set; default = 0; }


    /*
     * Constructors
     */
    public ResponseList() { }
    
    public ResponseList.from_data(string buffer) {
        this();
        Parser parser = new Parser();
        try {
            parser.load_from_data(buffer);

            build(parser.get_root());
        } catch ( Error e) {
            stdout.printf("Error: %s\n", e.message);
        }
    }

    public ResponseList.from_node(Json.Node node) {
        this();
        build(node);
    }

    public void load_from_data(string buffer) {
        clean();

        Parser parser = new Parser();
        try {
            parser.load_from_data(buffer);

            build(parser.get_root());
        } catch ( Error e ) {
            stdout.printf("Error: %s\n", e.message);
        }
    }

    private void clean() {
        response_by_id = new HashTable<string, Response>(GLib.str_hash, GLib.str_equal);
        response_list = new List<Response>();
    }

    private void build(Json.Node node) {
        if ( node.get_node_type() != NodeType.OBJECT ) {
            return;
        }

        Json.Object object = node.get_object();

        if ( !object.has_member(KEY_RESPONSES) ) {
            return;
        }

        responses_seen = object.get_int_member(KEY_RESPONSES_SEEN);

        if ( object.has_member(KEY_RESPONSE_COUNT) ) {
            response_count = object.get_int_member(KEY_RESPONSE_COUNT);
        }

        build_responses_only(object.get_member(KEY_RESPONSES));

        if ( !object.has_member(KEY_FRIENDS) ) {
            return;
        }

        unowned Json.Node user_list_node = object.get_member(KEY_FRIENDS);
        UserList user_list = new UserList.from_node(user_list_node);
        
        foreach ( Response response in response_list ) {
            User owner = user_list.get_id(response.user_id);

            if ( owner != null ) {
                response.owner = owner;
            }
        }
    }

    private void build_responses_only(Json.Node node) {
        if ( node.get_node_type() != NodeType.ARRAY ) {
            return;
        }

        foreach ( unowned Json.Node response_node in node.get_array().get_elements() ) {
            if ( response_node.get_node_type() != NodeType.OBJECT ) {
                continue;
            }

            Response response = new Response.from_node(response_node);
            response_by_id.replace(response.user_id, response);
            response_list.prepend(response);
        }
        response_list.reverse();
        
    }

    public uint get_count() {
        return response_by_id.size();
    }

    public Response get_id(string response_id) {
        return response_by_id.lookup(response_id);
    }

    public Response get_pos(uint index) {
        if ( index >= 0 ) {
            return response_list.nth_data(index);
        } else {
            uint roll = response_list.length();
            roll += index;
            return response_list.nth_data(roll);
        }
    }

    public List<Response> get_all() {
        return response_list.copy();
    }

}
