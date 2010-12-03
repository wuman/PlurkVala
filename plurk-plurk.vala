using Json;
using Soup;

public class PlurkVala.Plurk : GLib.Object {

    private static const string KEY_RESPONSES_SEEN = "responses_seen";
    private static const string KEY_QUALIFIER = "qualifier";
    private static const string KEY_PLURK_ID = "plurk_id";
    private static const string KEY_RESPONSE_COUNT = "response_count";
    private static const string KEY_LIMITED_TO = "limited_to";
    private static const string KEY_NO_COMMENTS = "no_comments";
    private static const string KEY_IS_UNREAD = "is_unread";
    private static const string KEY_LANGUAGE = "lang";
    private static const string KEY_CONTENT_RAW = "content_raw";
    private static const string KEY_USER_ID = "user_id";
    private static const string KEY_PLURK_TYPE = "plurk_type";
    private static const string KEY_CONTENT = "content";
    private static const string KEY_QUALIFIER_TRANSLATED = "qualifier_translated";
    private static const string KEY_POSTED = "posted";
    private static const string KEY_OWNER_ID = "owner_id";
    

    public int64 responses_seen { get; set; default = 0; }
    public Qualifier qualifier { get; set; default = Qualifier.DEFAULT; }
    public string plurk_id { get; set; default = null; }
    public int64 response_count { get; set; default = 0; }
    public string[] limited_to { get; set; default = null; }
    public NoCommentsValue no_comments { get; set; default = NoCommentsValue.RESPONSES_ENABLED_FOR_ALL; }
    public IsUnreadValue is_unread { get; set; default = IsUnreadValue.READ; }
    public PlurkApi.Language lang { get; set; default = PlurkApi.Language.EN; }    
    public string content_raw { get; set; default = null; }
    public string user_id { get; set; default = null; }
    public PlurkType plurk_type { get; set; default = PlurkType.PUBLIC_PLURK; }
    public string content { get; set; default = null; }
    public string qualifier_translated { get; set; default = null; }
    public unowned Soup.Date posted { get; set; default = null; }
    public string owner_id { get; set; default = null; }
    public User owner { get; set; default = null; }

    public static enum PlurkType {
        PUBLIC_PLURK = 0,
        PRIVATE_PLURK = 1,
        PUBLIC_PLURK_RESPONDED_BY_LOGGED_IN_USER = 2,
        PRIVATE_PLURK_RESPONDED_BY_LOGGED_IN_USER = 3;

        public static PlurkType from_int(int64 val) {
            switch (val) {
            case 1:
                return PRIVATE_PLURK;
            case 2:
                return PUBLIC_PLURK_RESPONDED_BY_LOGGED_IN_USER;
            case 3:
                return PRIVATE_PLURK_RESPONDED_BY_LOGGED_IN_USER;
            default:
                return PUBLIC_PLURK;
            }
        }
        
        public int to_int() {
            switch (this) {
            case PRIVATE_PLURK:
                return 1;
            case PUBLIC_PLURK_RESPONDED_BY_LOGGED_IN_USER:
                return 2;
            case PRIVATE_PLURK_RESPONDED_BY_LOGGED_IN_USER:
                return 3;
            default:
                return 0;
            }
        }
    }

    public static enum NoCommentsValue {
        RESPONSES_ENABLED_FOR_ALL = 0,
        RESPONSES_DISABLED = 1,
        ONLY_FRIENDS = 2;

        public static NoCommentsValue from_int(int64 val) {
            switch (val) {
            case 1:
                return RESPONSES_DISABLED;
            case 2:
                return ONLY_FRIENDS;
            default:
                return RESPONSES_ENABLED_FOR_ALL;
            }
        }

        public int to_int() {
            switch (this) {
            case RESPONSES_DISABLED:
                return 1;
            case ONLY_FRIENDS:
                return 2;
            default:
                return 0;
            }
        }
    }

    public static enum IsUnreadValue {
        READ = 0,
        UNREAD = 1,
        MUTED = 2;

        public static IsUnreadValue from_int(int64 val) {
            switch (val) {
            case 1:
                return UNREAD;
            case 2:
                return MUTED;
            default:
                return READ;
            }
        }

        public int to_int() {
            switch (this) {
            case UNREAD:
                return 1;
            case MUTED:
                return 2;
            default:
                return 0;
            }
        }
    }

    public static enum Qualifier {
        DEFAULT,
        LOVES,
        LIKES,
        SHARES,
        GIVES,
        HATES,
        WANTS,
        HAS,
        WILL,
        ASKS,
        WISHES,
        WAS,
        FEELS,
        THINKS,
        SAYS,
        IS,
        FREESTYLE,
        HOPES,
        NEEDS,
        WONDERS,

        N_QUALIFIERS;

        public static Qualifier from_string(string str) {
            switch (str) {
            case "loves":
                return LOVES;
            case "likes":
                return LIKES;
            case "shares":
                return SHARES;
            case "gives":
                return GIVES;
            case "hates":
                return HATES;
            case "wants":
                return WANTS;
            case "has":
                return HAS;
            case "will":
                return WILL;
            case "asks":
                return ASKS;
            case "wishes":
                return WISHES;
            case "was":
                return WAS;
            case "feels":
                return FEELS;
            case "thinks":
                return THINKS;
            case "says":
                return SAYS;
            case "is":
                return IS;
            case "freestyle":
                return FREESTYLE;
            case "hopes":
                return HOPES;
            case "needs":
                return NEEDS;
            case "wonders":
                return WONDERS;
            default:
                return DEFAULT;
            }
        }

        public string to_string() {
            switch (this) {
            case LOVES:
                return "loves";
            case LIKES:
                return "likes";
            case SHARES:
                return "shares";
            case GIVES:
                return "gives";
            case HATES:
                return "hates";
            case WANTS:
                return "wants";
            case HAS:
                return "has";
            case WILL:
                return "will";
            case ASKS:
                return "asks";
            case WISHES:
                return "wishes";
            case WAS:
                return "was";
            case FEELS:
                return "feels";
            case THINKS:
                return "thinks";
            case SAYS:
                return "says";
            case IS:
                return "is";
            case FREESTYLE:
                return "freestyle";
            case HOPES:
                return "hopes";
            case NEEDS:
                return "needs";
            case WONDERS:
                return "wonders";
            default:
                return ":";
            }
        }
    }

    
    /*
     * Constructors
     */
    public Plurk() { }

    public Plurk.from_data(string buffer) {
        this();
        Parser parser = new Parser();
        try {
            parser.load_from_data(buffer);

            build(parser.get_root());
        } catch ( Error e) {
            stdout.printf("Error: %s\n", e.message);
        }
    }

    public Plurk.from_node(Json.Node node) {
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
        responses_seen = 0;
        qualifier = Qualifier.DEFAULT;
        plurk_id = null;
        response_count = 0;
        limited_to = null;
        no_comments = NoCommentsValue.RESPONSES_ENABLED_FOR_ALL;
        is_unread = IsUnreadValue.READ;
        lang = PlurkApi.Language.EN;
        content_raw = null;
        plurk_type = PlurkType.PUBLIC_PLURK;
        content = null;
        qualifier_translated = null;
        posted = null;
        owner_id = null;
    }

    private void build(Json.Node node) {
        if ( node.get_node_type() != NodeType.OBJECT ) {
            return;
        }

        Json.Object object = node.get_object();

        unowned Json.Node node_responses_seen = object.get_member(KEY_RESPONSES_SEEN);
        if ( node_responses_seen != null ) {
            responses_seen = node_responses_seen.get_int();
        }
        
        unowned Json.Node node_qualifier = object.get_member(KEY_QUALIFIER);
        if ( node_qualifier != null ) {
            qualifier = Qualifier.from_string(node_qualifier.get_string());
        }
        
        unowned Json.Node node_plurk_id = object.get_member(KEY_PLURK_ID);
        if ( node_plurk_id != null ) {
            plurk_id = node_plurk_id.get_int().to_string();
        }
        
        unowned Json.Node node_response_count = object.get_member(KEY_RESPONSE_COUNT);
        if ( node_response_count != null ) {
            response_count = node_response_count.get_int();
        }
        
        unowned Json.Node node_limited_to = object.get_member(KEY_LIMITED_TO);
        if ( node_limited_to != null && node_limited_to.get_node_type() == NodeType.ARRAY ) {
            Json.Array array = node_limited_to.get_array();
            if ( array.get_length() > 0 ) {
                List<Json.Node> elements = array.get_elements();
                uint length = elements.length();
                limited_to = new string[length];
                for ( int i = 0; i < length; i++ ) {
                    limited_to[i] = elements.nth_data(i).get_int().to_string();
                }
            }
        }

        unowned Json.Node node_no_comments = object.get_member(KEY_NO_COMMENTS);
        if ( node_no_comments != null ) {
            no_comments = NoCommentsValue.from_int(node_no_comments.get_int());
        }

        unowned Json.Node node_is_unread = object.get_member(KEY_IS_UNREAD);
        if ( node_is_unread != null ) {
            is_unread = IsUnreadValue.from_int(node_is_unread.get_int());
        }

        unowned Json.Node node_lang = object.get_member(KEY_LANGUAGE);
        if ( node_lang != null ) {
            lang = PlurkApi.Language.from_string(node_lang.get_string());
        }

        unowned Json.Node node_content_raw = object.get_member(KEY_CONTENT_RAW);
        if ( node_content_raw != null ) {
            content_raw = node_content_raw.dup_string();
        }

        unowned Json.Node node_user_id = object.get_member(KEY_USER_ID);
        if ( node_user_id != null ) {
            user_id = node_user_id.get_int().to_string();
        }

        unowned Json.Node node_plurk_type = object.get_member(KEY_PLURK_TYPE);
        if ( node_plurk_type != null ) {
            plurk_type = PlurkType.from_int(node_plurk_type.get_int());
        }

        unowned Json.Node node_content = object.get_member(KEY_CONTENT);
        if ( node_content != null ) {
            content = node_content.dup_string();
        }

        unowned Json.Node node_q_translated = object.get_member(KEY_QUALIFIER_TRANSLATED);
        if ( node_q_translated != null ) {
            qualifier_translated = node_q_translated.dup_string();
        }

        unowned Json.Node node_posted = object.get_member(KEY_POSTED);
        if ( node_posted != null && node_posted.get_node_type() != NodeType.NULL ) {
            posted = new Soup.Date.from_string(node_posted.get_string());
        }

        unowned Json.Node node_owner_id = object.get_member(KEY_OWNER_ID);
        if ( node_owner_id != null ) {
            owner_id = node_owner_id.get_int().to_string();
        }
    }

}
