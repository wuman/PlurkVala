using Json;

public class Roguso.PlurkList : GLib.Object {

    private static const string KEY_PLURKS = "plurks";
    private static const string KEY_PLURK_USERS = "plurk_users";

    private HashTable<string, Plurk> plurk_by_id = new HashTable<string, Plurk>(GLib.str_hash, GLib.str_equal);
    private List<Plurk> plurk_list = new List<Plurk>();

    /*
     * Constructors
     */
    public PlurkList() { }
    
    public PlurkList.from_data(string buffer) {
        this();
        Parser parser = new Parser();
        try {
            parser.load_from_data(buffer);

            build(parser.get_root());
        } catch ( Error e) {
            stdout.printf("Error: %s\n", e.message);
        }
    }

    public PlurkList.from_node(Json.Node node) {
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
        plurk_by_id = new HashTable<string, Plurk>(GLib.str_hash, GLib.str_equal);
        plurk_list = new List<Plurk>();
    }

    private void build(Json.Node node) {
        if ( node.get_node_type() != NodeType.OBJECT ) {
            return;
        }

        Json.Object object = node.get_object();

        if ( !object.has_member(KEY_PLURKS) ) {
            return;
        }

        build_plurks_only(object.get_member(KEY_PLURKS));

        if ( !object.has_member(KEY_PLURK_USERS) ) {
            return;
        }

        unowned Json.Node user_list_node = object.get_member(KEY_PLURK_USERS);
        UserList user_list = new UserList.from_node(user_list_node);

        foreach ( Plurk plurk in plurk_list ) {
            User owner = user_list.get_id(plurk.owner_id);

            if ( owner != null ) {
                plurk.owner = owner;
            }
        }
    }

    private void build_plurks_only(Json.Node node) {
        if ( node.get_node_type() != NodeType.ARRAY ) {
            return;
        }

        foreach ( unowned Json.Node plurk_node in node.get_array().get_elements() ) {
            if ( plurk_node.get_node_type() != NodeType.OBJECT ) {
                continue;
            }

            Plurk plurk = new Plurk.from_node(plurk_node);
            plurk_by_id.replace(plurk.plurk_id, plurk);
            plurk_list.prepend(plurk);
        }
        plurk_list.reverse();
    }

    public uint get_count() {
        return plurk_by_id.size();
    }

    public Plurk get_id(string plurk_id) {
        return plurk_by_id.lookup(plurk_id);
    }

    public Plurk get_pos(uint index) {
        if ( index >= 0 ) {
            return plurk_list.nth_data(index);
        } else {
            uint roll = plurk_list.length();
            roll += index;
            return plurk_list.nth_data(roll);
        }
    }

    public List<Plurk> get_all() {
        return plurk_list.copy();
    }

}
