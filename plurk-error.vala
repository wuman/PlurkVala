namespace Plurk {

    public static const Quark PLURK_ERROR_DOMAIN = Quark.from_string("plurk-error");

    public static enum PlurkError {
        // Client library error
        JSON_PARSING_ERROR,

        // Miscellaneous
        INVALID_PASSWORD,
        INVALID_API_KEY,

        // /Users/register
        INVALID_EMAIL,
        USER_ALREADY_FOUND,
        EMAIL_ALREADY_FOUND,
        PASSWORD_TOO_SMALL,
        NICK_NAME_TOO_SHORT,
        INVALID_NICK_NAME,
        INTERNAL_SERVICE_ERROR,
        INVALID_GENDER,
        INVALID_DATE_OF_BIRTH,

        // /Users/login
        INVALID_LOGIN,
        TOO_MANY_LOGINS,

        // /Users/update
        INVALID_CURRENT_PASSWORD,
        DISPLAY_NAME_TOO_LONG,
        INVALID_PRIVACY,

        // /Users/updatePicture
        REQUIRES_LOGIN,
        UNSUPPORTED_IMAGE_FORMAT,

        // /Profile/getPublicProfile
        INVALID_USER_ID,
        USER_NOT_FOUND,

        // /Timeline/getPlurk
        OWNER_NOT_FOUND,
        PLURK_NOT_FOUND,
        NO_PERMISSIONS,

        // /Timeline/getPlurks
        UNKNOWN_FILTER,

        // /Timeline/plurkAdd
        INVALID_DATA,
        MUST_BE_FRIENDS,
        EMPTY_CONTENT,
        ANTI_FLOOD_SAME_CONTENT,
        ANTI_FLOOD_TOO_MANY_NEW,

        // /Timeline/uploadPicture
        INVALID_FILE,
        INVALID_IMAGE,

        // /Responses/responseAdd
        CONTENT_TOO_LONG,

        // /FriendsFans/becomeFriend
        USER_CANNOT_BEFRIENDED,
        USER_ALREADY_BEFRIENDED,

        // /FriendsFans/setFollowing
        USER_MUST_BE_BEFRIENDED_BEFORE_FOLLOWING,
        INVALID_FOLLOW,

        // /Cliques/add
        CLIQUE_NOT_CREATED,

        // General
        UNKNOWN;

        public static PlurkError from_msg(string msg) {
            switch ( msg ) {
            case "JSON parsing failed":
                return JSON_PARSING_ERROR;
            case "Invalid password":
                return INVALID_PASSWORD;
            case "Invalid API key":
                return INVALID_API_KEY;
            case "Email invalid":
                return INVALID_EMAIL;
            case "User already found":
                return USER_ALREADY_FOUND;
            case "Email already found":
                return EMAIL_ALREADY_FOUND;
            case "Password too small":
                return PASSWORD_TOO_SMALL;
            case "Nick name must be at least 3 characters long":
                return NICK_NAME_TOO_SHORT;
            case "Nick name can only contain letters, numbers and _":
                return INVALID_NICK_NAME;
            case "Internal service error. Please, try later":
                return INTERNAL_SERVICE_ERROR;
            case "Invalid gender parameter":
                return INVALID_GENDER;
            case "Invalid date_of_birth parameter, should be YYYY-MM-DD":
                return INVALID_DATE_OF_BIRTH;
            case "Invalid login":
                return INVALID_LOGIN;
            case "Too many logins":
                return TOO_MANY_LOGINS;
            case "Invalid current password":
                return INVALID_CURRENT_PASSWORD;
            case "Display name too long, should be less than 15 characters long":
                return DISPLAY_NAME_TOO_LONG;
            case "Invalid privacy parameter, should be \"world\", \"only_friends\" or \"only_me\"":
                return INVALID_PRIVACY;
            case "Requires login":
                return REQUIRES_LOGIN;
            case "Not supported image format or image too big":
                return UNSUPPORTED_IMAGE_FORMAT;
            case "Invalid user_id":
                return INVALID_USER_ID;
            case "User not found":
                return USER_NOT_FOUND;
            case "Plurk owner not found":
                return OWNER_NOT_FOUND;
            case "Plurk not found":
                return PLURK_NOT_FOUND;
            case "No permissions":
                return NO_PERMISSIONS;
            case "Invalid data":
                return INVALID_DATA;
            case "Must be friends":
                return MUST_BE_FRIENDS;
            case "Content is empty":
                return EMPTY_CONTENT;
            case "anti-flood-same-content":
                return ANTI_FLOOD_SAME_CONTENT;
            case "anti-flood-too-many-new":
                return ANTI_FLOOD_TOO_MANY_NEW;
            case "Invalid file":
                return INVALID_FILE;
            case "Image not provided, be sure to do a multipart/form-data POST request":
                return INVALID_IMAGE;
            case "Content too long":
                return CONTENT_TOO_LONG;
            case "User can't be befriended":
                return USER_CANNOT_BEFRIENDED;
            case "User already befriended":
                return USER_ALREADY_BEFRIENDED;
            case "User must be befriended before you can follow them":
                return USER_MUST_BE_BEFRIENDED_BEFORE_FOLLOWING;
            case "Invalid value of `follow`, should be `true` or `false`":
                return INVALID_FOLLOW;
            case "Clique not created":
                return CLIQUE_NOT_CREATED;
            default:
                return UNKNOWN;
            }
        }

    }

}
