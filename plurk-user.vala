using Json;
using Soup;

public class Roguso.User : GLib.Object {

    // Minimal data
    private static const string KEY_USER_ID = "id";
    private static const string KEY_NICK_NAME = "nick_name";
    private static const string KEY_DISPLAY_NAME = "display_name";
    private static const string KEY_GENDER = "gender";
    private static const string KEY_HAS_PROFILE_IMAGE = "has_profile_image";
    private static const string KEY_AVATAR = "avatar";

    // Full data
    private static const string KEY_FULL_NAME = "full_name";
    private static const string KEY_LOCATION = "location";
    private static const string KEY_DATE_OF_BIRTH = "date_of_birth";
    private static const string KEY_RELATIONSHIP = "relationship";
    private static const string KEY_PAGE_TITLE = "page_title";
    private static const string KEY_RECRUITED = "recruited";
    private static const string KEY_KARMA = "karma";
    private static const string KEY_IS_PREMIUM = "is_premium";
    private static const string KEY_TIMEZONE = "timezone";

    public string user_id { get; set; default = null; }
    public string nick_name { get; set; default = null; }
    public string display_name { get; set; default = null; }
    public Gender gender { get; set; default = Gender.NOT_STATING_OR_OTHER; }
    public bool has_profile_image { get; set; default = false; }
    public int64 avatar_version { get; set; default = 0; }
    public string full_name { get; set; default = null; }
    public string location { get; set; default = null; }
    public unowned Soup.Date date_of_birth { get; set; default = null; }
    public Relationship relationship { get; set; default = Relationship.NOT_SAYING; }
    public string page_title { get; set; default = null; }
    public int64 recruited { get; set; default = 0; }
    public double karma { get; set; default = 0.0; }
    public bool is_premium { get; set; default = false; }

    public static enum Relationship {
        NOT_SAYING,
        SINGLE,
        MARRIED,
        DIVORCED,
        ENGAGED,
        IN_RELATIONSHIP,
        COMPLICATED,
        WIDOWED,
        OPEN_RELATIONSHIP;

        public static Relationship from_string(string val) {
            switch (val) {
            case "single":
                return SINGLE;
            case "married":
                return MARRIED;
            case "divorced":
                return DIVORCED;
            case "engaged":
                return ENGAGED;
            case "in_relationship":
                return IN_RELATIONSHIP;
            case "complicated":
                return COMPLICATED;
            case "widowed":
                return WIDOWED;
            case "open_relationship":
                return OPEN_RELATIONSHIP;
            default:
                return NOT_SAYING;
            }
        }

        public string to_string() {
            switch (this) {
            case SINGLE:
                return "single";
            case MARRIED:
                return "married";
            case DIVORCED:
                return "divorced";
            case ENGAGED:
                return "engaged";
            case IN_RELATIONSHIP:
                return "in_relationship";
            case COMPLICATED:
                return "complicated";
            case WIDOWED:
                return "widowed";
            case OPEN_RELATIONSHIP:
                return "open_relationship";
            default:
                return "not_saying";
            }
        }
    }


    public static enum Gender {
        MALE = 0,
        FEMALE = 1,
        NOT_STATING_OR_OTHER = 2;

        public static Gender from_int(int64 val) {
            switch (val) {
            case 0:
                return MALE;
            case 1:
                return FEMALE;
            default:
                return NOT_STATING_OR_OTHER;
            }
        }

        public int to_int() {
            switch (this) {
            case MALE:
                return 0;
            case FEMALE:
                return 1;
            default:
                return 2;
            }
        }
    }
    
    
    /*
     * Constructors
     */
    public User() { }

    public User.from_data(string buffer) {
        this();
        Parser parser = new Parser();
        try {
            parser.load_from_data(buffer);

            build(parser.get_root());
        } catch ( Error e) {
            stdout.printf("Error: %s\n", e.message);
        }
    }

    public User.from_node(Json.Node node) {
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
        user_id = null;
        nick_name = null;
        display_name = null;
        gender = Gender.NOT_STATING_OR_OTHER;
        has_profile_image = false;
        avatar_version = 0;
        full_name = null;
        location = null;
        date_of_birth = null;
        relationship = Relationship.NOT_SAYING;
        page_title = null;
        recruited = 0;
        karma = 0.0;
        is_premium = false;
    }

    private void build(Json.Node node) {
        if ( node.get_node_type() != NodeType.OBJECT ) {
            return;
        }

        Json.Object object = node.get_object();

        unowned Json.Node node_user_id = object.get_member(KEY_USER_ID);
        if ( node_user_id != null ) {
            user_id = node_user_id.get_int().to_string();
        }

        unowned Json.Node node_nick_name = object.get_member(KEY_NICK_NAME);
        if ( node_nick_name != null ) {
            nick_name = node_nick_name.dup_string();
        }

        unowned Json.Node node_display_name = object.get_member(KEY_DISPLAY_NAME);
        if ( node_display_name != null ) {
            display_name = node_display_name.dup_string();
        }

        unowned Json.Node node_gender = object.get_member(KEY_GENDER);
        if ( node_gender != null ) {
            gender = Gender.from_int(node_gender.get_int());
        }

        unowned Json.Node node_has_profile_image = object.get_member(KEY_HAS_PROFILE_IMAGE);
        if ( node_has_profile_image != null ) {
            has_profile_image = ( node_has_profile_image.get_int() == 1 );
        }

        unowned Json.Node node_avatar_version = object.get_member(KEY_AVATAR);
        if ( node_avatar_version != null && node_avatar_version.get_node_type() == NodeType.VALUE ) {
            avatar_version = node_avatar_version.get_int();
        }

        unowned Json.Node node_full_name = object.get_member(KEY_FULL_NAME);
        if ( node_full_name != null ) {
            full_name = node_full_name.dup_string();
        }

        unowned Json.Node node_location = object.get_member(KEY_LOCATION);
        if ( node_location != null ) {
            location = node_location.dup_string();
        }

        unowned Json.Node node_date_of_birth = object.get_member(KEY_DATE_OF_BIRTH);
        if ( node_date_of_birth != null && node_date_of_birth.get_node_type() != NodeType.NULL ) {
            date_of_birth = new Soup.Date.from_string(node_date_of_birth.get_string());
        }

        unowned Json.Node node_relationship = object.get_member(KEY_RELATIONSHIP);
        if ( node_relationship != null ) {
            relationship = Relationship.from_string(node_relationship.get_string());
        }

        unowned Json.Node node_page_title = object.get_member(KEY_PAGE_TITLE);
        if ( node_page_title != null ) {
            page_title = node_page_title.dup_string();
        }

        unowned Json.Node node_recruited = object.get_member(KEY_RECRUITED);
        if ( node_recruited != null ) {
            recruited = node_recruited.get_int();
        }

        unowned Json.Node node_karma = object.get_member(KEY_KARMA);
        if ( node_karma != null ) {
            karma = node_karma.get_double();
        }

        unowned Json.Node node_is_premium = object.get_member(KEY_IS_PREMIUM);
        if ( node_is_premium != null ) {
            is_premium = node_is_premium.get_boolean();
        }
    }
    
}
