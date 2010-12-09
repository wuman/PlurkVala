using Soup;
using Json;

public class Roguso.PlurkApi : GLib.Object {

    private string api_key;

    private static const string METHOD_GET = "GET";
    private static const string METHOD_POST = "POST";
    private static const string URI_SCHEME_HTTP = "http";
    private static const string URI_SCHEME_HTTPS = "https";
    private static const string FORM_MIME_TYPE_MULTIPART = "multipart/form-data";
    private static const string FORM_MIME_TYPE_URLENCODED = "application/x-www-form-urlencoded";

    private static const string API_HOST = "www.plurk.com/API/";
    private static const string API_BASE_URL = URI_SCHEME_HTTP + "://" + API_HOST;
    private static const string SECURE_API_BASE_URL = URI_SCHEME_HTTPS + "://" + API_HOST;

    private static const string USER_REGISTER = "Users/register";
    private static const string USER_LOGIN = "Users/login";
    private static const string USER_LOGOUT = "Users/logout";
    private static const string USER_UPDATE = "Users/update";
    private static const string USER_UPDATE_PICTURE = "Users/updatePicture";
    private static const string USER_GET_KARMA_STATS = "Users/getKarmaStats";

    private static const string PROFILE_GET_OWN = "Profile/getOwnProfile";
    private static const string PROFILE_GET_PUBLIC = "Profile/getPublicProfile";

    private static const string POLLING_GET_PLURKS = "Polling/getPlurks";
    private static const string POLLING_GET_UNREAD_COUNT = "Polling/getUnreadCount";

    private static const string TIMELINE_GET_PLURK = "Timeline/getPlurk";
    private static const string TIMELINE_GET_PLURKS = "Timeline/getPlurks";
    private static const string TIMELINE_GET_UNREAD_PLURKS = "Timeline/getUnreadPlurks";
    private static const string TIMELINE_ADD_PLURK = "Timeline/plurkAdd";
    private static const string TIMELINE_DELETE_PLURK = "Timeline/plurkDelete";
    private static const string TIMELINE_EDIT_PLURK = "Timeline/plurkEdit";
    private static const string TIMELINE_MUTE_PLURKS = "Timeline/mutePlurks";
    private static const string TIMELINE_UNMUTE_PLURKS = "Timeline/unmutePlurks";
    private static const string TIMELINE_FAVORITE_PLURKS = "Timeline/favoritePlurks";
    private static const string TIMELINE_UNFAVORITE_PLURKS = "Timeline/unfavoritePlurks";
    private static const string TIMELINE_MARK_AS_READ = "Timeline/markAsRead";
    private static const string TIMELINE_UPLOAD_PICTURE = "Timeline/uploadPicture";

    private static const string RESPONSES_GET = "Responses/get";
    private static const string RESPONSES_ADD = "Responses/responseAdd";
    private static const string RESPONSES_DELETE = "Responses/responseDelete";

    private static const string FRIENDS_GET = "FriendsFans/getFriendsByOffset";
    private static const string FANS_GET = "FriendsFans/getFansByOffset";
    private static const string FOLLOWING_GET = "FriendsFans/getFollowingByOffset";
    private static const string FRIEND_REQUEST = "FriendsFans/becomeFriend";
    private static const string FRIEND_REMOVE = "FriendsFans/removeAsFriend";
    private static const string FAN_REQUEST = "FriendsFans/becomeFan";
    private static const string FOLLOWING_SET = "FriendsFans/setFollowing";
    private static const string COMPLETION_GET = "FriendsFans/getCompletion";

    private static const string ALERTS_GET_ACTIVE = "Alerts/getActive";
    private static const string ALERTS_GET_HISTORY = "Alerts/getHistory";
    private static const string ALERTS_ADD_AS_FAN = "Alerts/addAsFan";
    private static const string ALERTS_ADD_ALL_AS_FANS = "Alerts/addAllAsFan";
    private static const string ALERTS_ADD_ALL_AS_FRIENDS = "Alerts/addAllAsFriends";
    private static const string ALERTS_ACCEPT_FRIENDSHIP = "Alerts/addAsFriend";
    private static const string ALERTS_DENY_FRIENDSHIP = "Alerts/denyFriendship";
    private static const string ALERTS_REMOVE_NOTIFICATION = "Alerts/removeNotification";

    private static const string SEARCH_PLURKS = "PlurkSearch/search";
    private static const string SEARCH_USERS = "UserSearch/search";

    private static const string EMOTICONS_GET = "Emoticons/get";

    private static const string BLOCKS_GET = "Blocks/get";
    private static const string BLOCKS_ADD = "Blocks/block";
    private static const string BLOCKS_REMOVE = "Blocks/unblock";

    private static const string CLIQUES_GET_ALL = "Cliques/getCliques";
    private static const string CLIQUES_GET = "Cliques/getClique";
    private static const string CLIQUES_CREATE = "Cliques/createClique";
    private static const string CLIQUES_RENAME = "Cliques/renameClique";
    private static const string CLIQUES_ADD_FRIEND = "Cliques/add";
    private static const string CLIQUES_REMOVE_FRIEND = "Cliques/remove";

    public static const string PARAM_API_KEY = "api_key";
    public static const string PARAM_USERNAME = "username";
    public static const string PARAM_PASSWORD = "password";
    public static const string PARAM_NO_DATA = "no_data";
    public static const string PARAM_USER_ID = "user_id";
    public static const string PARAM_FRIEND_ID = "friend_id";
    public static const string PARAM_FAN_ID = "fan_id";
    public static const string PARAM_PLURK_ID = "plurk_id";
    public static const string PARAM_RESPONSE_ID = "response_id";
    public static const string PARAM_OFFSET = "offset";
    public static const string PARAM_LIMIT = "limit";
    public static const string PARAM_FILTER = "filter";
    public static const string PARAM_ONLY_USER = "only_user";
    public static const string PARAM_CONTENT = "content";
    public static const string PARAM_QUALIFIER = "qualifier";
    public static const string PARAM_LIMITED_TO = "limited_to";
    public static const string PARAM_NO_COMMENTS = "no_comments";
    public static const string PARAM_IDS = "ids";
    public static const string PARAM_FOLLOW = "follow";
    public static const string PARAM_NOTE_POSITION = "note_position";
    public static const string PARAM_FROM_RESPONSE = "from_response";
    public static const string PARAM_QUERY = "query";
    public static const string PARAM_MINIMAL_DATA = "minimal_data";
    public static const string PARAM_LANGUAGE = "lang";
    public static const string PARAM_CLIQUE_NAME = "clique_name";
    public static const string PARAM_NEW_NAME = "new_name";

    public static enum Language {
        EN,
        PT_BR,
        CN,
        CA,
        EL,
        DK,
        DE,
        ES,
        SV,
        NB,
        HI,
        RO,
        HR,
        FR,
        RU,
        IT,
        JA,
        HE,
        HU,
        NE,
        TH,
        TA_FP,
        IN,
        PL,
        AR,
        FI,
        TR_CH,
        TR,
        GA,
        SK,
        UK,
        FA,

        N_LANGUAGES;

        public static Language from_string(string val) {
            switch (val) {
            case "pt_BR":
                return PT_BR;
            case "cn":
                return CN;
            case "ca":
                return CA;
            case "el":
                return EL;
            case "dk":
                return DK;
            case "de":
                return DE;
            case "es":
                return ES;
            case "sv":
                return SV;
            case "nb":
                return NB;
            case "hi":
                return HI;
            case "ro":
                return RO;
            case "hr":
                return HR;
            case "fr":
                return FR;
            case "ru":
                return RU;
            case "it":
                return IT;
            case "ja":
                return JA;
            case "he":
                return HE;
            case "hu":
                return HU;
            case "ne":
                return NE;
            case "th":
                return TH;
            case "ta_fp":
                return TA_FP;
            case "in":
                return IN;
            case "pl":
                return PL;
            case "ar":
                return AR;
            case "fi":
                return FI;
            case "tr_ch":
                return TR_CH;
            case "tr":
                return TR;
            case "ga":
                return GA;
            case "sk":
                return SK;
            case "uk":
                return UK;
            case "fa":
                return FA;
            default:
                return EN;
            }
        }

        public string to_string() {
            switch (this) {
            case PT_BR:
                return "pt_BR";
            case CN:
                return "cn";
            case CA:
                return "ca";
            case EL:
                return "el";
            case DK:
                return "dk";
            case DE:
                return "de";
            case ES:
                return "es";
            case SV:
                return "sv";
            case NB:
                return "nb";
            case HI:
                return "hi";
            case RO:
                return "ro";
            case HR:
                return "hr";
            case FR:
                return "fr";
            case RU:
                return "ru";
            case IT:
                return "it";
            case JA:
                return "ja";
            case HE:
                return "he";
            case HU:
                return "hu";
            case NE:
                return "ne";
            case TH:
                return "th";
            case TA_FP:
                return "ta_fp";
            case IN:
                return "in";
            case PL:
                return "pl";
            case AR:
                return "ar";
            case FI:
                return "fi";
            case TR_CH:
                return "tr_ch";
            case TR:
                return "tr";
            case GA:
                return "ga";
            case SK:
                return "sk";
            case UK:
                return "uk";
            case FA:
                return "fa";
            default:
                return "en";
            }
        }        
    }

    public static enum PlurkFilterType {
        ALL,
        ONLY_USER,
        ONLY_RESPONDED,
        ONLY_PRIVATE,
        ONLY_FAVORITE,

        N_FILTER_TYPES;

        public string to_string() {
            switch (this) {
            case ONLY_USER:
                return "only_user";
            case ONLY_RESPONDED:
                return "only_responded";
            case ONLY_PRIVATE:
                return "only_private";
            case ONLY_FAVORITE:
                return "only_favorite";
            default:
                return "";
            }
        }

        public static PlurkFilterType from_string(string str) {
            switch (str) {
            case "only_user":
                return ONLY_USER;
            case "only_responded":
                return ONLY_RESPONDED;
            case "only_private":
                return ONLY_PRIVATE;
            case "only_favorite":
                return ONLY_FAVORITE;
            default:
                return ALL;
            }
        }
    }

    public PlurkApi(string api_key) {
        this.api_key = api_key;
    }

    public Message login(string username, string password, bool no_data = false) {
        HashTable<string, string> hash = new HashTable<string, string>(GLib.str_hash, GLib.str_equal);
        hash.insert(PARAM_API_KEY, api_key);
        hash.insert(PARAM_USERNAME, username);
        hash.insert(PARAM_PASSWORD, password);
        if ( no_data ) {
            hash.insert(PARAM_NO_DATA, true.to_string());
        }
        unowned string params =  Soup.form_encode_hash(hash);
        Message msg = new Message(METHOD_POST, "%s%s?%s".printf(SECURE_API_BASE_URL, USER_LOGIN, params));
        free((void *) params);
        return msg;
    }

    public Message logout() {
        unowned string params =  Soup.form_encode(PARAM_API_KEY, api_key, null);
        Message msg = new Message(METHOD_GET, "%s%s?%s".printf(API_BASE_URL, USER_LOGOUT, params));
        free((void *) params);
        return msg;
    }
    
    public Message get_karma_stats() {
        unowned string params =  Soup.form_encode(PARAM_API_KEY, api_key, null);
        Message msg = new Message(METHOD_GET, "%s%s?%s".printf(API_BASE_URL, USER_GET_KARMA_STATS, params));
        free((void *) params);
        return msg;
    }

    public Message get_own_profile() {
        unowned string params =  Soup.form_encode(PARAM_API_KEY, api_key, null);
        Message msg = new Message(METHOD_GET, "%s%s?%s".printf(API_BASE_URL, PROFILE_GET_OWN, params));
        free((void *) params);
        return msg;
    }

    public Message get_public_profile(string nickname) {
        unowned string params =  Soup.form_encode(PARAM_API_KEY, api_key, PARAM_USER_ID, nickname, null);
        Message msg = new Message(METHOD_GET, "%s%s?%s".printf(API_BASE_URL, PROFILE_GET_PUBLIC, params));
        free((void *) params);
        return msg;
    }

    public Message polling_get_plurks(Soup.Date offset, int limit = 0) {
        if ( limit <= 0 ) {
            limit = 50;
        }
        unowned string params =  Soup.form_encode(PARAM_API_KEY, api_key, PARAM_OFFSET, offset.to_string(DateFormat.ISO8601_XMLRPC), PARAM_LIMIT, limit, null);
        Message msg = new Message(METHOD_GET, "%s%s?%s".printf(API_BASE_URL, POLLING_GET_PLURKS, params));
        free((void *) params);
        return msg;
    }

    public Message polling_get_unread_count() {
        unowned string params =  Soup.form_encode(PARAM_API_KEY, api_key, null);
        Message msg = new Message(METHOD_GET, "%s%s?%s".printf(API_BASE_URL, POLLING_GET_UNREAD_COUNT, params));
        free((void *) params);
        return msg;
    }

    public Message timeline_get_plurk(string plurk_id) {
        unowned string params =  Soup.form_encode(PARAM_API_KEY, api_key, PARAM_PLURK_ID, plurk_id, null);
        Message msg = new Message(METHOD_GET, "%s%s?%s".printf(API_BASE_URL, TIMELINE_GET_PLURK, params));
        free((void *) params);
        return msg;
    }

    public Message timeline_get_plurks(Soup.Date? offset, int limit = 0, PlurkFilterType filter = PlurkFilterType.ALL) {
        HashTable<string, string> hash = new HashTable<string, string>(GLib.str_hash, GLib.str_equal);
        hash.insert(PARAM_API_KEY, api_key);
        if ( offset != null ) {
            hash.insert(PARAM_OFFSET, offset.to_string(DateFormat.ISO8601_XMLRPC));
        }
        if ( limit > 0 ) {
            hash.insert(PARAM_LIMIT, limit.to_string());
        }
        if ( filter > PlurkFilterType.ALL && filter < PlurkFilterType.N_FILTER_TYPES ) {
            if ( filter != PlurkFilterType.ONLY_USER ) {
                hash.insert(PARAM_FILTER, filter.to_string());
            } else {
                hash.insert(PARAM_ONLY_USER, true.to_string());
            }
        }
        unowned string params =  Soup.form_encode_hash(hash);
        Message msg = new Message(METHOD_GET, "%s%s?%s".printf(API_BASE_URL, TIMELINE_GET_PLURKS, params));
        free((void *) params);
        return msg;
    }

    public Message timeline_get_unread_plurks(Soup.Date? offset, int limit = 0) {
        HashTable<string, string> hash = new HashTable<string, string>(GLib.str_hash, GLib.str_equal);
        hash.insert(PARAM_API_KEY, api_key);
        if ( offset != null ) {
            hash.insert(PARAM_OFFSET, offset.to_string(DateFormat.ISO8601_XMLRPC));
        }
        if ( limit > 0 ) {
            hash.insert(PARAM_LIMIT, limit.to_string());
        }
        unowned string params =  Soup.form_encode_hash(hash);
        Message msg = new Message(METHOD_GET, "%s%s?%s".printf(API_BASE_URL, TIMELINE_GET_UNREAD_PLURKS, params));
        free((void *) params);
        return msg;
    }

    public Message add_plurk(string content, 
            Plurk.Qualifier qualifier = Plurk.Qualifier.DEFAULT, 
            string[]? limited_to, 
            Plurk.NoCommentsValue no_comments = Plurk.NoCommentsValue.RESPONSES_ENABLED_FOR_ALL,
            Language language = Language.EN) {
        HashTable<string, string> hash = new HashTable<string, string>(GLib.str_hash, GLib.str_equal);
        hash.insert(PARAM_API_KEY, api_key);
        hash.insert(PARAM_CONTENT, content);
        hash.insert(PARAM_QUALIFIER, qualifier.to_string());

        if ( limited_to != null && limited_to.length > 0 ) {
            string json = json_string_from_string_array(limited_to);
            hash.insert(PARAM_LIMITED_TO, json);
        }

        if ( no_comments != Plurk.NoCommentsValue.RESPONSES_ENABLED_FOR_ALL ) {
            hash.insert(PARAM_NO_COMMENTS, no_comments.to_int().to_string());
        }

        if ( language != Language.EN ) {
            hash.insert(PARAM_LANGUAGE, language.to_string());
        }

        unowned string params =  Soup.form_encode_hash(hash);
        Message msg = new Message(METHOD_POST, API_BASE_URL + TIMELINE_ADD_PLURK);
        msg.set_request(FORM_MIME_TYPE_URLENCODED, MemoryUse.COPY, params, params.size());
        free((void *) params);
        return msg;
    }

    public Message delete_plurk(string plurk_id) {
        unowned string params =  Soup.form_encode(PARAM_API_KEY, api_key, PARAM_PLURK_ID, plurk_id, null);
        Message msg = new Message(METHOD_GET, "%s%s?%s".printf(API_BASE_URL, TIMELINE_DELETE_PLURK, params));
        free((void *) params);
        return msg;
    }

    public Message edit_plurk(string plurk_id, string content) {
        unowned string params =  Soup.form_encode(PARAM_API_KEY, api_key, PARAM_PLURK_ID, plurk_id, PARAM_CONTENT, content, null);
        Message msg = new Message(METHOD_GET, "%s%s?%s".printf(API_BASE_URL, TIMELINE_EDIT_PLURK, params));
        free((void *) params);
        return msg;
    }

    public Message mute_plurks(string[] ids) {
        string json = json_string_from_string_array(ids);
        unowned string params =  Soup.form_encode(PARAM_API_KEY, api_key, PARAM_IDS, json, null);
        Message msg = new Message(METHOD_GET, "%s%s?%s".printf(API_BASE_URL, TIMELINE_MUTE_PLURKS, params));
        free((void *) params);
        return msg;
    }

    public Message unmute_plurks(string[] ids) {
        string json = json_string_from_string_array(ids);
        unowned string params =  Soup.form_encode(PARAM_API_KEY, api_key, PARAM_IDS, json, null);
        Message msg = new Message(METHOD_GET, "%s%s?%s".printf(API_BASE_URL, TIMELINE_UNMUTE_PLURKS, params));
        free((void *) params);
        return msg;
    }

    public Message favorite_plurks(string[] ids) {
        string json = json_string_from_string_array(ids);
        unowned string params =  Soup.form_encode(PARAM_API_KEY, api_key, PARAM_IDS, json, null);
        Message msg = new Message(METHOD_GET, "%s%s?%s".printf(API_BASE_URL, TIMELINE_FAVORITE_PLURKS, params));
        free((void *) params);
        return msg;
    }

    public Message unfavorite_plurks(string[] ids) {
        string json = json_string_from_string_array(ids);
        unowned string params =  Soup.form_encode(PARAM_API_KEY, api_key, PARAM_IDS, json, null);
        Message msg = new Message(METHOD_GET, "%s%s?%s".printf(API_BASE_URL, TIMELINE_UNFAVORITE_PLURKS, params));
        free((void *) params);
        return msg;
    }

    public Message mark_plurks_as_read(string[] ids, bool note_position = false) {
        string json = json_string_from_string_array(ids);
        HashTable<string, string> hash = new HashTable<string, string>(GLib.str_hash, GLib.str_equal);
        hash.insert(PARAM_API_KEY, api_key);
        hash.insert(PARAM_IDS, json);
        if ( note_position ) {
            hash.insert(PARAM_NOTE_POSITION, "true");
        }
        unowned string params =  Soup.form_encode_hash(hash);
        Message msg = new Message(METHOD_POST, API_BASE_URL + TIMELINE_MARK_AS_READ);
        msg.set_request(FORM_MIME_TYPE_URLENCODED, MemoryUse.COPY, params, params.size());
        free((void *) params);
        return msg;
    }

    private static string json_string_from_string_array(string[] str) {
        size_t length;
        string json;

        Generator generator = new Generator();
        Json.Node root = new Json.Node(NodeType.ARRAY);
        Json.Array array = new Json.Array();
        root.set_array(array);
        generator.set_root(root);

        foreach ( string el in str ) {
            array.add_int_element(el.to_int());
        }

        json = generator.to_data(out length);
        return json;
    }

    public Message get_responses(string plurk_id, uint from_response = 0) {
        unowned string params =  Soup.form_encode(PARAM_API_KEY, api_key, PARAM_PLURK_ID, plurk_id, PARAM_FROM_RESPONSE, from_response.to_string(), null);
        Message msg = new Message(METHOD_GET, "%s%s?%s".printf(API_BASE_URL, RESPONSES_GET, params));
        free((void *) params);
        return msg;
    }

    public Message add_response(string plurk_id, string content, Plurk.Qualifier qualifier = Plurk.Qualifier.DEFAULT) {
        unowned string params =  Soup.form_encode(PARAM_API_KEY, api_key, PARAM_PLURK_ID, plurk_id, PARAM_CONTENT, content, PARAM_QUALIFIER, qualifier.to_string(), null);
        Message msg = new Message(METHOD_POST, API_BASE_URL + RESPONSES_ADD);
        msg.set_request(FORM_MIME_TYPE_URLENCODED, MemoryUse.COPY, params, params.size());
        free((void *) params);
        return msg;
    }

    public Message delete_response(string plurk_id, string response_id) {
        unowned string params =  Soup.form_encode(PARAM_API_KEY, api_key, PARAM_PLURK_ID, plurk_id, PARAM_RESPONSE_ID, response_id, null);
        Message msg = new Message(METHOD_GET, "%s%s?%s".printf(API_BASE_URL, RESPONSES_DELETE, params));
        free((void *) params);
        return msg;
    }

    public Message get_friends(string user_id, int offset = 0) {
        HashTable<string, string> hash = new HashTable<string, string>(GLib.str_hash, GLib.str_equal);
        hash.insert(PARAM_API_KEY, api_key);
        hash.insert(PARAM_USER_ID, user_id);
        if ( offset > 0 ) {
            hash.insert(PARAM_OFFSET, offset.to_string());
        }
        unowned string params =  Soup.form_encode_hash(hash);
        Message msg = new Message(METHOD_GET, "%s%s?%s".printf(API_BASE_URL, FRIENDS_GET, params));
        free((void *) params);
        return msg;
    }

    public Message get_fans(string user_id, int offset = 0) {
        HashTable<string, string> hash = new HashTable<string, string>(GLib.str_hash, GLib.str_equal);
        hash.insert(PARAM_API_KEY, api_key);
        hash.insert(PARAM_USER_ID, user_id);
        if ( offset > 0 ) {
            hash.insert(PARAM_OFFSET, offset.to_string());
        }
        unowned string params =  Soup.form_encode_hash(hash);
        Message msg = new Message(METHOD_GET, "%s%s?%s".printf(API_BASE_URL, FANS_GET, params));
        free((void *) params);
        return msg;
    }

    public Message get_followings(int offset = 0) {
        HashTable<string, string> hash = new HashTable<string, string>(GLib.str_hash, GLib.str_equal);
        hash.insert(PARAM_API_KEY, api_key);
        if ( offset > 0 ) {
            hash.insert(PARAM_OFFSET, offset.to_string());
        }
        unowned string params =  Soup.form_encode_hash(hash);
        Message msg = new Message(METHOD_GET, "%s%s?%s".printf(API_BASE_URL, FOLLOWING_GET, params));
        free((void *) params);
        return msg;
    }

    public Message become_friends_with(string friend_id) {
        unowned string params =  Soup.form_encode(PARAM_API_KEY, api_key, PARAM_FRIEND_ID, friend_id, null);
        Message msg = new Message(METHOD_GET, "%s%s?%s".printf(API_BASE_URL, FRIEND_REQUEST, params));
        free((void *) params);
        return msg;
    }

    public Message remove_friend(string friend_id) {
        unowned string params =  Soup.form_encode(PARAM_API_KEY, api_key, PARAM_FRIEND_ID, friend_id, null);
        Message msg = new Message(METHOD_GET, "%s%s?%s".printf(API_BASE_URL, FRIEND_REMOVE, params));
        free((void *) params);
        return msg;
    }

    public Message become_fan(string fan_id) {
        unowned string params =  Soup.form_encode(PARAM_API_KEY, api_key, PARAM_FAN_ID, fan_id, null);
        Message msg = new Message(METHOD_GET, "%s%s?%s".printf(API_BASE_URL, FAN_REQUEST, params));
        free((void *) params);
        return msg;
    }

    public Message set_following(string user_id, bool follow) {
        unowned string params =  Soup.form_encode(PARAM_API_KEY, api_key, PARAM_USER_ID, user_id, PARAM_FOLLOW, follow.to_string(), null);
        Message msg = new Message(METHOD_GET, "%s%s?%s".printf(API_BASE_URL, FOLLOWING_SET, params));
        free((void *) params);
        return msg;
    }

    public Message get_completion() {
        unowned string params =  Soup.form_encode(PARAM_API_KEY, api_key, null);
        Message msg = new Message(METHOD_GET, "%s%s?%s".printf(API_BASE_URL, COMPLETION_GET, params));
        free((void *) params);
        return msg;
    }

    public Message get_active_alerts() {
        unowned string params =  Soup.form_encode(PARAM_API_KEY, api_key, null);
        Message msg = new Message(METHOD_GET, "%s%s?%s".printf(API_BASE_URL, ALERTS_GET_ACTIVE, params));
        free((void *) params);
        return msg;
    }

    public Message get_history_alerts() {
        unowned string params =  Soup.form_encode(PARAM_API_KEY, api_key, null);
        Message msg = new Message(METHOD_GET, "%s%s?%s".printf(API_BASE_URL, ALERTS_GET_HISTORY, params));
        free((void *) params);
        return msg;
    }

    public Message add_user_as_fan(string user_id) {
        unowned string params =  Soup.form_encode(PARAM_API_KEY, api_key, PARAM_USER_ID, user_id, null);
        Message msg = new Message(METHOD_GET, "%s%s?%s".printf(API_BASE_URL, ALERTS_ADD_AS_FAN, params));
        free((void *) params);
        return msg;
    }

    public Message add_all_as_fans() {
        unowned string params =  Soup.form_encode(PARAM_API_KEY, api_key, null);
        Message msg = new Message(METHOD_POST, API_BASE_URL + ALERTS_ADD_ALL_AS_FANS);
        msg.set_request(FORM_MIME_TYPE_URLENCODED, MemoryUse.COPY, params, params.size());
        free((void *) params);
        return msg;
    }

    public Message add_all_as_friends() {
        unowned string params =  Soup.form_encode(PARAM_API_KEY, api_key, null);
        Message msg = new Message(METHOD_POST, API_BASE_URL + ALERTS_ADD_ALL_AS_FRIENDS);
        msg.set_request(FORM_MIME_TYPE_URLENCODED, MemoryUse.COPY, params, params.size());
        free((void *) params);
        return msg;
    }

    public Message accept_user_as_friend(string user_id) {
        unowned string params =  Soup.form_encode(PARAM_API_KEY, api_key, PARAM_USER_ID, user_id, null);
        Message msg = new Message(METHOD_POST, API_BASE_URL + ALERTS_ACCEPT_FRIENDSHIP);
        msg.set_request(FORM_MIME_TYPE_URLENCODED, MemoryUse.COPY, params, params.size());
        free((void *) params);
        return msg;
    }

    public Message deny_user_friendship(string user_id) {
        unowned string params =  Soup.form_encode(PARAM_API_KEY, api_key, PARAM_USER_ID, user_id, null);
        Message msg = new Message(METHOD_POST, API_BASE_URL + ALERTS_DENY_FRIENDSHIP);
        msg.set_request(FORM_MIME_TYPE_URLENCODED, MemoryUse.COPY, params, params.size());
        free((void *) params);
        return msg;
    }

    public Message search_plurks(string query, string? plurk_id) {
        HashTable<string, string> hash = new HashTable<string, string>(GLib.str_hash, GLib.str_equal);
        hash.insert(PARAM_API_KEY, api_key);
        hash.insert(PARAM_QUERY, query);
        if ( plurk_id != null ) {
            hash.insert(PARAM_OFFSET, plurk_id);
        }
        unowned string params =  Soup.form_encode_hash(hash);
        Message msg = new Message(METHOD_POST, API_BASE_URL + SEARCH_PLURKS);
        msg.set_request(FORM_MIME_TYPE_URLENCODED, MemoryUse.COPY, params, params.size());
        free((void *) params);
        return msg;
    }

    public Message search_users(string query, int offset = 0) {
        HashTable<string, string> hash = new HashTable<string, string>(GLib.str_hash, GLib.str_equal);
        hash.insert(PARAM_API_KEY, api_key);
        hash.insert(PARAM_QUERY, query);
        if ( offset > 0 ) {
            hash.insert(PARAM_OFFSET, offset.to_string());
        }
        unowned string params =  Soup.form_encode_hash(hash);
        Message msg = new Message(METHOD_POST, API_BASE_URL + SEARCH_USERS);
        msg.set_request(FORM_MIME_TYPE_URLENCODED, MemoryUse.COPY, params, params.size());
        free((void *) params);
        return msg;
    }

    public Message get_emoticons() {
        unowned string params =  Soup.form_encode(PARAM_API_KEY, api_key, null);
        Message msg = new Message(METHOD_GET, "%s%s?%s".printf(API_BASE_URL, EMOTICONS_GET, params));
        free((void *) params);
        return msg;
    }

    public Message get_cliques() {
        unowned string params = Soup.form_encode(PARAM_API_KEY, api_key, null);
        Message msg = new Message(METHOD_GET, "%s%s?%s".printf(API_BASE_URL, CLIQUES_GET_ALL, params));
        free((void *) params);
        return msg;
    }

    public Message get_clique_users(string clique_name) {
        unowned string params = Soup.form_encode(PARAM_API_KEY, api_key, PARAM_CLIQUE_NAME, clique_name, null);
        Message msg = new Message(METHOD_GET, "%s%s?%s".printf(API_BASE_URL, CLIQUES_GET, params));
        free((void *) params);
        return msg;
    }

    public Message create_clique(string clique_name) {
        unowned string params = Soup.form_encode(PARAM_API_KEY, api_key, PARAM_CLIQUE_NAME, clique_name, null);
        Message msg = new Message(METHOD_GET, "%s%s?%s".printf(API_BASE_URL, CLIQUES_CREATE, params));
        free((void *) params);
        return msg;
    }

    public Message rename_clique(string clique_name, string new_name) {
        unowned string params = Soup.form_encode(PARAM_API_KEY, api_key, PARAM_CLIQUE_NAME, clique_name, PARAM_NEW_NAME, new_name, null);
        Message msg = new Message(METHOD_GET, "%s%s?%s".printf(API_BASE_URL, CLIQUES_RENAME, params));
        free((void *) params);
        return msg;
    }

    public Message add_user_to_clique(string clique_name, string user_id) {
        unowned string params = Soup.form_encode(PARAM_API_KEY, api_key, PARAM_CLIQUE_NAME, clique_name, PARAM_USER_ID, user_id, null);
        Message msg = new Message(METHOD_GET, "%s%s?%s".printf(API_BASE_URL, CLIQUES_ADD_FRIEND, params));
        free((void *) params);
        return msg;
    }

    public Message remove_user_from_clique(string clique_name, string user_id) {
        unowned string params = Soup.form_encode(PARAM_API_KEY, api_key, PARAM_CLIQUE_NAME, clique_name, PARAM_USER_ID, user_id, null);
        Message msg = new Message(METHOD_GET, "%s%s?%s".printf(API_BASE_URL, CLIQUES_REMOVE_FRIEND, params));
        free((void *) params);
        return msg;
    }

}
