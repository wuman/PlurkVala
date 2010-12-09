using Json;
using Soup;

public class Plurk.Response : GLib.Object {

    private static const string KEY_RESPONSE_ID = "id";
    private static const string KEY_PLURK_ID = "plurk_id";
    private static const string KEY_USER_ID = "user_id";
    private static const string KEY_LANGUAGE = "lang";
    private static const string KEY_CONTENT_RAW = "content_raw";
    private static const string KEY_QUALIFIER = "qualifier";
    private static const string KEY_CONTENT = "content";
    private static const string KEY_POSTED = "posted";

    public string response_id { get; set; default = null; }
    public string plurk_id { get; set; default = null; }
    public string user_id { get; set; default = null; }
    public PlurkApi.Language lang { get; set; default = PlurkApi.Language.EN; }
    public string content_raw { get; set; default = null; }
    public Plurk.Qualifier qualifier { get; set; default = Plurk.Qualifier.DEFAULT; }
    public string content { get; set; default = null; }
    public unowned Soup.Date posted { get; set; default = null; }
    public User owner { get; set; default = null; }
    
    
    /*
     * Constructors
     */
    public Response() { }

    public Response.from_data(string buffer) {
        this();
        Parser parser = new Parser();
        try {
            parser.load_from_data(buffer);

            build(parser.get_root());
        } catch ( Error e) {
            stdout.printf("Error: %s\n", e.message);
        }
    }

    public Response.from_node(Json.Node node) {
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
        response_id = null;
        plurk_id = null;
        user_id = null;
        lang = PlurkApi.Language.EN;
        content_raw = null;
        qualifier = Plurk.Qualifier.DEFAULT;
        content = null;
        posted = null;
        owner = null;
    }

    private void build(Json.Node node) {
        if ( node.get_node_type() != NodeType.OBJECT ) {
            return;
        }

        Json.Object object = node.get_object();

        response_id = object.get_int_member(KEY_RESPONSE_ID).to_string();

        plurk_id = object.get_int_member(KEY_PLURK_ID).to_string();

        user_id = object.get_int_member(KEY_USER_ID).to_string();

        lang = PlurkApi.Language.from_string(object.get_string_member(KEY_LANGUAGE));
        
        content_raw = object.get_string_member(KEY_CONTENT_RAW);

        qualifier = Plurk.Qualifier.from_string(object.get_string_member(KEY_QUALIFIER));
        
        content = object.get_string_member(KEY_CONTENT);

        posted = new Soup.Date.from_string(object.get_string_member(KEY_POSTED));
    }

}
