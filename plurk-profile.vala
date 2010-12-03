using Json;
using Soup;

public class PlurkVala.Profile : GLib.Object {

    private static const string KEY_FANS_COUNT = "fans_count";
    private static const string KEY_ALERTS_COUNT = "alerts_count";
    private static const string KEY_FRIENDS_COUNT = "friends_count";
    private static const string KEY_UNREAD_COUNT = "unread_count";
    private static const string KEY_PRIVACY = "privacy";
    private static const string KEY_HAS_READ_PERMISSION = "has_read_permission";
    private static const string KEY_USER_INFO = "user_info";

    public int64 fans_count { get; set; default = 0; }
    public int64 alerts_count { get; set; default = 0; }
    public int64 friends_count { get; set; default = 0; }
    public int64 unread_count { get; set; default = 0; }
    public Privacy privacy { get; set; default = Privacy.WORLD; }
    public bool has_read_permission { get; set; default = true; }
    public User user { get; set; default = null; }

    public static enum Privacy {
        WORLD,
        ONLY_FRIENDS,
        ONLY_ME;

        public static Privacy from_string(string val) {
            switch (val) {
            case "only_friends":
                return ONLY_FRIENDS;
            case "only_me":
                return ONLY_ME;
            default:
                return WORLD;
            }
        }
        
        public string to_string() {
            switch (this) {
            case ONLY_FRIENDS:
                return "only_friends";
            case ONLY_ME:
                return "only_me";
            default:
                return "world";
            }
        }
    }

    
    /*
     * Constructors
     */
    public Profile() { }

    public Profile.from_data(string buffer) {
        this();
        Parser parser = new Parser();
        try {
            parser.load_from_data(buffer);

            build(parser.get_root());
        } catch ( Error e) {
            stdout.printf("Error: %s\n", e.message);
        }
    }

    public Profile.from_node(Json.Node node) {
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
        fans_count = 0;
        alerts_count = 0;
        friends_count = 0;
        unread_count = 0;
        privacy = Privacy.WORLD;
        has_read_permission = true;
        user = null;
    }

    private void build(Json.Node node) {
        if ( node.get_node_type() != NodeType.OBJECT ) {
            return;
        }

        Json.Object object = node.get_object();

        unowned Json.Node node_fans_count = object.get_member(KEY_FANS_COUNT);
        if ( node_fans_count != null ) {
            fans_count = node_fans_count.get_int();
        }

        unowned Json.Node node_alerts_count = object.get_member(KEY_ALERTS_COUNT);
        if ( node_alerts_count != null ) {
            alerts_count = node_alerts_count.get_int();
        }

        unowned Json.Node node_friends_count = object.get_member(KEY_FRIENDS_COUNT);
        if ( node_friends_count != null ) {
            friends_count = node_friends_count.get_int();
        }

        unowned Json.Node node_unread_count = object.get_member(KEY_UNREAD_COUNT);
        if ( node_unread_count != null ) {
            unread_count = node_unread_count.get_int();
        }
        
        unowned Json.Node node_privacy = object.get_member(KEY_PRIVACY);
        if ( node_privacy != null ) {
            privacy = Privacy.from_string(node_privacy.get_string());
        }

        unowned Json.Node node_has_read_permission = object.get_member(KEY_HAS_READ_PERMISSION);
        if ( node_has_read_permission != null ) {
            has_read_permission = node_has_read_permission.get_boolean();
        }

        unowned Json.Node node_user = object.get_member(KEY_USER_INFO);
        if ( node_user != null && node_user.get_node_type() == NodeType.OBJECT ) {
            User userinfo = new User.from_node(node_user);
            user = userinfo;
        }
        
    }

}
