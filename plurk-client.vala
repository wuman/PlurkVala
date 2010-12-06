using Soup;
using Json;

public class PlurkVala.PlurkClient : GLib.Object {

    private static const string PLURKVALA_USER_AGENT = "PlurkVala 0.1";
    private static const int SESSION_MAX_CONNS = 1;

    private string username;
    private string password;
    private Profile profile;
    private string user_agent = PLURKVALA_USER_AGENT;
    private Session session;
    private CookieJar cookies;

    public signal void authenticate(Error? e, bool is_logged_in);
    public signal void plurk_received(Error? e, Plurk? plurk);
    public signal void timeline_complete(Error? e, PlurkList? plurks);
    public signal void response_received(Error? e, Response? response);
    public signal void responses_complete(Error? e, string? plurk_id, int from_response, ResponseList? responses);
    public signal void plurks_muted(Error? e, string[] plurk_ids);
    public signal void plurks_unmuted(Error? e, string[] plurk_ids);
    public signal void plurks_favorited(Error? e, string[] plurk_ids);
    public signal void plurks_unfavorited(Error? e, string[] plurk_ids);
    public signal void plurk_deleted(Error? e, string plurk_id);
    public signal void response_deleted(Error? e, string plurk_id, string response_id);
    public signal void karma_received(Error? e, double karma);
    public signal void profile_received(Error? e, Profile? profile);
    public signal void cliques_received(Error? e, string[] cliques);
    public signal void clique_users_received(Error? e, string clique_name, UserList? users);
    public signal void clique_created(Error? e, string clique_name);
    public signal void clique_renamed(Error? e, string clique_name, string new_name);
    public signal void user_added_to_clique(Error? e, string clique_name, string user_id);
    public signal void user_removed_from_clique(Error? e, string clique_name, string user_id);

    private static enum Action {
        LOGIN,
        LOGOUT,
        GET_KARMA_STATS,
        GET_OWN_PROFILE,
        GET_PUBLIC_PROFILE,
        GET_TIMELINE,
        GET_UNREAD_TIMELINE,
        GET_PLURK,
        GET_RESPONSES,
        MUTE_PLURKS,
        UNMUTE_PLURKS,
        FAVORITE_PLURKS,
        UNFAVORITE_PLURKS,
        ADD_PLURK,
        EDIT_PLURK,
        DELETE_PLURK,
        ADD_RESPONSE,
        DELETE_RESPONSE,
        GET_CLIQUES,
        GET_CLIQUE_USERS,
        CREATE_CLIQUE,
        RENAME_CLIQUE,
        ADD_USER_TO_CLIQUE,
        REMOVE_USER_FROM_CLIQUE;
    }


    /*
     * Constructors
     */
    public PlurkClient() {
        cookies = new CookieJar();
        session = new SessionAsync.with_options(
            "user-agent", user_agent, 
            Soup.SESSION_MAX_CONNS, SESSION_MAX_CONNS, 
            null);
        session.add_feature = cookies;
    }

    public PlurkClient.for_user(string username, string password) {
        this();
        this.username = username.dup();
        this.password = password.dup();
    }

    public void get_account(out string username, out string password) {
        username = this.username.dup();
        password = this.password.dup();
    }

    public void login(bool no_data = false) {
        Message msg = PlurkApi.login(username, password, no_data);
        session.queue_message(msg, (s, m) => {
            bool success;
            Error error = on_request_responded_cb(s, m, Action.LOGIN, out success);

            authenticate(error, success);

            if ( success ) {
                HashTable<string, string> form_data = Soup.form_decode(m.uri.query);
                string nodata = form_data.lookup(PlurkApi.PARAM_NO_DATA);
                if ( nodata == null || !nodata.to_bool() ) {
                    profile = new Profile.from_data(m.response_body.flatten().data);
                    profile_received(null, profile);
                }
            }
        });
    }

    public void logout() {
        Message msg = PlurkApi.logout();
        session.queue_message(msg, (s, m) => {
            bool success;
            Error error = on_request_responded_cb(s, m, Action.LOGOUT, out success);
            authenticate(error, !success);
        });
    }

    public void mute_plurks(string[] ids) {
        if ( ids.length <= 0 ) {
            return;
        }

        Message msg = PlurkApi.mute_plurks(ids);
        session.queue_message(msg, (s, m) => {
            bool success;
            Error error = on_request_responded_cb(s, m, Action.MUTE_PLURKS, out success);
            if ( success ) {
                on_mute_plurks_cb(s, m);
            } else {
                plurks_muted(error, new string[0]);
            }
        });
    }

    public void unmute_plurks(string[] ids) {
        if ( ids.length <= 0 ) {
            return;
        }

        Message msg = PlurkApi.unmute_plurks(ids);
        session.queue_message(msg, (s, m) => {
            bool success;
            Error error = on_request_responded_cb(s, m, Action.UNMUTE_PLURKS, out success);
            if ( success ) {
                on_unmute_plurks_cb(s, m);
            } else {
                plurks_unmuted(error, new string[0]);
            }
        });
    }

    public void favorite_plurks(string[] ids) {
        if ( ids.length <= 0 ) {
            return;
        }

        Message msg = PlurkApi.favorite_plurks(ids);
        session.queue_message(msg, (s, m) => {
            bool success;
            Error error = on_request_responded_cb(s, m, Action.FAVORITE_PLURKS, out success);
            if ( success ) {
                on_favorite_plurks_cb(s, m);
            } else {
                plurks_favorited(error, new string[0]);
            }
        });
    }

    public void unfavorite_plurks(string[] ids) {
        if ( ids.length <= 0 ) {
            return;
        }

        Message msg = PlurkApi.unfavorite_plurks(ids);
        session.queue_message(msg, (s, m) => {
            bool success;
            Error error = on_request_responded_cb(s, m, Action.UNFAVORITE_PLURKS, out success);
            if ( success ) {
                on_unfavorite_plurks_cb(s, m);
            } else {
                plurks_unfavorited(error, new string[0]);
            }
        });
    }

    public void get_timeline(Soup.Date? offset, int limit = 0, PlurkApi.PlurkFilterType filter = PlurkApi.PlurkFilterType.ALL) {
        Message msg = PlurkApi.timeline_get_plurks(offset, limit, filter);
        session.queue_message(msg, (s, m) => {
            bool success;
            Error error = on_request_responded_cb(s, m, Action.GET_TIMELINE, out success);
            if ( success ) {
                on_get_timeline_cb(s, m);
            } else {
                timeline_complete(error, null);
            }
        });
    }

    public void get_unread_timeline(Soup.Date? offset, int limit = 0) {
        Message msg = PlurkApi.timeline_get_unread_plurks(offset, limit);
        session.queue_message(msg, (s, m) => {
            bool success;
            Error error = on_request_responded_cb(s, m, Action.GET_UNREAD_TIMELINE, out success);
            if ( success ) {
                on_get_timeline_cb(s, m);
            } else {
                timeline_complete(error, null);
            }
        });
    }

    public void get_plurk(string plurk_id) {
        Message msg = PlurkApi.timeline_get_plurk(plurk_id);
        session.queue_message(msg, (s, m) => {
            bool success;
            Error error = on_request_responded_cb(s, m, Action.GET_PLURK, out success);
            if ( success ) {
                on_get_plurk_cb(s, m);
            } else {
                plurk_received(error, null);
            }
        });
    }

    public void get_responses(string plurk_id, int from_response = 0) {
        Message msg = PlurkApi.get_responses(plurk_id, from_response);
        session.queue_message(msg, (s, m) => {
            bool success;
            Error error = on_request_responded_cb(s, m, Action.GET_RESPONSES, out success);
            if ( success ) {
                on_get_responses_cb(s, m);
            } else {
                responses_complete(error, null, 0, null);
            }
        });
    }

    public void add_plurk(string content,
            Plurk.Qualifier qualifier = Plurk.Qualifier.DEFAULT,
            string[]? limited_to,
            Plurk.NoCommentsValue no_comments = Plurk.NoCommentsValue.RESPONSES_ENABLED_FOR_ALL,
            PlurkApi.Language language = PlurkApi.Language.EN) {
        Message msg = PlurkApi.add_plurk(content, qualifier, limited_to, no_comments, language);
        session.queue_message(msg, (s, m) => {
            bool success;
            Error error = on_request_responded_cb(s, m, Action.ADD_PLURK, out success);
            if ( success ) {
                on_get_plurk_cb(s, m);
            } else {
                plurk_received(error, null);
            }
        });
    }

    public void edit_plurk(string plurk_id, string content) {
        Message msg = PlurkApi.edit_plurk(plurk_id, content);
        session.queue_message(msg, (s, m) => {
            bool success;
            Error error = on_request_responded_cb(s, m, Action.EDIT_PLURK, out success);
            if ( success ) {
                on_get_plurk_cb(s, m);
            } else {
                plurk_received(error, null);
            }
        });
    }

    public void delete_plurk(string plurk_id) {
        Message msg = PlurkApi.delete_plurk(plurk_id);
        session.queue_message(msg, (s, m) => {
            bool success;
            Error error = on_request_responded_cb(s, m, Action.DELETE_PLURK, out success);
            on_delete_plurk_cb(s, m, success, error);
        });
    }

    public void add_response(string plurk_id, string content, Plurk.Qualifier qualifier = Plurk.Qualifier.DEFAULT) {
        Message msg = PlurkApi.add_response(plurk_id, content, qualifier);
        session.queue_message(msg, (s, m) => {
            bool success;
            Error error = on_request_responded_cb(s, m, Action.ADD_RESPONSE, out success);
            if ( success ) {
                on_get_response_cb(s, m);
            } else {
                response_received(error, null);
            }
        });
    }

    public void delete_response(string plurk_id, string response_id) {
        Message msg = PlurkApi.delete_response(plurk_id, response_id);
        session.queue_message(msg, (s, m) => {
            bool success;
            Error error = on_request_responded_cb(s, m, Action.DELETE_RESPONSE, out success);
            on_delete_response_cb(s, m, success, error);
        });
    }

    public void get_karma() {
        Message msg = PlurkApi.get_karma_stats();
        session.queue_message(msg, (s, m) => {
            bool success;
            Error error = on_request_responded_cb(s, m, Action.GET_KARMA_STATS, out success);
            if ( success ) {
                on_get_karma_stats_cb(s, m);
            } else {
                karma_received(error, 0.0);
            }
        });
    }

    public void get_cliques() {
        Message msg = PlurkApi.get_cliques();
        session.queue_message(msg, (s, m) => {
            bool success;
            Error error = on_request_responded_cb(s, m, Action.GET_CLIQUES, out success);
            if ( success ) {
                on_get_cliques_cb(s, m);
            } else {
                cliques_received(error, new string[0]);
            }
        });
    }

    public void get_clique_users(string clique_name) {
        Message msg = PlurkApi.get_clique_users(clique_name);
        session.queue_message(msg, (s, m) => {
            bool success;
            Error error = on_request_responded_cb(s, m, Action.GET_CLIQUE_USERS, out success);
            if ( success ) {
                on_get_clique_users_cb(s, m);
            } else {
                HashTable<string, string> form_data = Soup.form_decode(m.uri.query);
                string cliquename = form_data.lookup(PlurkApi.PARAM_CLIQUE_NAME);
                clique_users_received(error, cliquename, null);
            }
        });
    }

    public void create_clique(string clique_name) {
        Message msg = PlurkApi.create_clique(clique_name);
        session.queue_message(msg, (s, m) => {
            bool success;
            Error error = on_request_responded_cb(s, m, Action.CREATE_CLIQUE, out success);
            HashTable<string, string> form_data = Soup.form_decode(m.uri.query);
            string cliquename = form_data.lookup(PlurkApi.PARAM_CLIQUE_NAME);
            clique_created(success ? null : error, cliquename);
        });
    }

    public void rename_clique(string clique_name, string new_name) {
        Message msg = PlurkApi.rename_clique(clique_name, new_name);
        session.queue_message(msg, (s, m) => {
            bool success;
            Error error = on_request_responded_cb(s, m, Action.RENAME_CLIQUE, out success);
            HashTable<string, string> form_data = Soup.form_decode(m.uri.query);
            string cliquename = form_data.lookup(PlurkApi.PARAM_CLIQUE_NAME);
            string newname = form_data.lookup(PlurkApi.PARAM_NEW_NAME);
            clique_renamed(success ? null : error, cliquename, newname);
        });
    }

    public void get_own_profile() {
        Message msg = PlurkApi.get_own_profile();
        session.queue_message(msg, (s, m) => {
            bool success;
            Error error = on_request_responded_cb(s, m, Action.GET_OWN_PROFILE, out success);
            if ( success ) {
                on_get_profile_cb(s, m);
            } else {
                profile_received(error, null);
            }
        });
    }

    public void get_public_profile(string user_id) {
        Message msg = PlurkApi.get_public_profile(user_id);
        session.queue_message(msg, (s, m) => {
            bool success;
            Error error = on_request_responded_cb(s, m, Action.GET_PUBLIC_PROFILE, out success);
            if ( success ) {
                on_get_profile_cb(s, m);
            } else {
                profile_received(error, null);
            }
        });
    }

    private static Error on_request_responded_cb(Session session, Message msg, Action action, out bool is_successful) {
        Error error;
        string error_msg = null;

        if ( msg.status_code >= 200 && msg.status_code < 300 ) {
            is_successful = true;
            error = null;
            return error;
        }

        is_successful = false;

        try {
            string buffer = msg.response_body.flatten().data;
            Parser parser = new Parser();
            parser.load_from_data(buffer);
            unowned Json.Object object = parser.get_root().get_object();
            unowned string error_text = object.get_string_member("error_text");
            error_msg = error_text.dup();
        } catch ( Error e ) {
            error = new Error(PLURK_ERROR_DOMAIN, PlurkError.JSON_PARSING_ERROR, "%d: %s", e.code, e.message);
            return error;
        }

        switch ( action ) {
        case Action.LOGIN:
        case Action.LOGOUT:
        case Action.GET_KARMA_STATS:
        case Action.GET_OWN_PROFILE:
        case Action.GET_PUBLIC_PROFILE:
        case Action.GET_TIMELINE:
        case Action.GET_UNREAD_TIMELINE:
        case Action.GET_PLURK:
        case Action.ADD_PLURK:
        case Action.EDIT_PLURK:
        case Action.DELETE_PLURK:
        case Action.GET_RESPONSES:
        case Action.DELETE_RESPONSE:
        case Action.ADD_RESPONSE:
        case Action.MUTE_PLURKS:
        case Action.UNMUTE_PLURKS:
        case Action.FAVORITE_PLURKS:
        case Action.UNFAVORITE_PLURKS:
        case Action.GET_CLIQUES:
        case Action.GET_CLIQUE_USERS:
        case Action.CREATE_CLIQUE:
        case Action.RENAME_CLIQUE:
        case Action.ADD_USER_TO_CLIQUE:
        case Action.REMOVE_USER_FROM_CLIQUE:
            int code = (int) PlurkError.from_msg(error_msg);
            error = new Error(PLURK_ERROR_DOMAIN, code, "%s", error_msg);
            break;
        default:
            error = new Error(PLURK_ERROR_DOMAIN, (int) PlurkError.UNKNOWN, "%s", "Unknown error");
            break;
        }

        return error;
    }

    private void on_get_timeline_cb(Session session, Message msg) {
        string buffer = msg.response_body.flatten().data;
        PlurkList plurks = new PlurkList.from_data(buffer);
        uint index = 0;
        Idle.add(() => {
            if ( index >= plurks.get_count() ) {
                timeline_complete(null, plurks);
                return false;
            }
            Plurk plurk = plurks.get_pos(index++);
            plurk_received(null, plurk);
            return true;
        });
    }

    private void on_get_plurk_cb(Session session, Message msg) {
        string buffer = msg.response_body.flatten().data;
        Plurk plurk = new Plurk.from_data(buffer);
        Idle.add(() => {
            plurk_received(null, plurk);
            return false;
        });
    }

    private void on_get_response_cb(Session session, Message msg) {
        string buffer = msg.response_body.flatten().data;
        Response response = new Response.from_data(buffer);
        Idle.add(() => {
            response_received(null, response);
            return false;
        });
    }

    private void on_get_responses_cb(Session session, Message msg) {
        HashTable<string, string> form_data = Soup.form_decode(msg.uri.query);
        string plurk_id = form_data.lookup(PlurkApi.PARAM_PLURK_ID);
        int from_response = form_data.lookup(PlurkApi.PARAM_FROM_RESPONSE).to_int();
        string buffer = msg.response_body.flatten().data;
        ResponseList responses = new ResponseList.from_data(buffer);
        uint index = 0;
        Idle.add(() => {
            if ( index >= responses.get_count() ) {
                responses_complete(null, plurk_id, from_response, responses);
                return false;
            }
            Response response = responses.get_pos(index++);
            response_received(null, response);
            return true;
        });
    }

    private void on_get_profile_cb(Session session, Message msg) {
        string buffer = msg.response_body.flatten().data;
        Profile profile = new Profile.from_data(buffer);
        profile_received(null, profile);
    }

    private void on_mute_plurks_cb(Session session, Message msg) {
        HashTable<string, string> form_data = Soup.form_decode(msg.uri.query);
        string ids = form_data.lookup(PlurkApi.PARAM_IDS);
        string[] plurk_ids = ids[2:ids.length-2].split(", ");
        plurks_muted(null, plurk_ids);
    }

    private void on_unmute_plurks_cb(Session session, Message msg) {
        HashTable<string, string> form_data = Soup.form_decode(msg.uri.query);
        string ids = form_data.lookup(PlurkApi.PARAM_IDS);
        string[] plurk_ids = ids[2:ids.length-2].split(", ");
        plurks_unmuted(null, plurk_ids);
    }

    private void on_favorite_plurks_cb(Session session, Message msg) {
        HashTable<string, string> form_data = Soup.form_decode(msg.uri.query);
        string ids = form_data.lookup(PlurkApi.PARAM_IDS);
        string[] plurk_ids = ids[2:ids.length-2].split(", ");
        plurks_favorited(null, plurk_ids);
    }

    private void on_unfavorite_plurks_cb(Session session, Message msg) {
        HashTable<string, string> form_data = Soup.form_decode(msg.uri.query);
        string ids = form_data.lookup(PlurkApi.PARAM_IDS);
        string[] plurk_ids = ids[2:ids.length-2].split(", ");
        plurks_unfavorited(null, plurk_ids);
    }

    private void on_delete_plurk_cb(Session session, Message msg, bool success, Error? e) {
        HashTable<string, string> form_data = Soup.form_decode(msg.uri.query);
        string plurk_id = form_data.lookup(PlurkApi.PARAM_PLURK_ID);
        plurk_deleted(success ? null : e, plurk_id);
    }

    private void on_delete_response_cb(Session session, Message msg, bool success, Error? e) {
        HashTable<string, string> form_data = Soup.form_decode(msg.uri.query);
        string plurk_id = form_data.lookup(PlurkApi.PARAM_PLURK_ID);
        string response_id = form_data.lookup(PlurkApi.PARAM_RESPONSE_ID);
        response_deleted(success ? null : e, plurk_id, response_id);
    }

    private void on_get_karma_stats_cb(Session session, Message msg) {
        string buffer = msg.response_body.flatten().data;
        try {
            Parser parser = new Parser();
            parser.load_from_data(buffer);
            unowned Json.Object object = parser.get_root().get_object();
            double karma = object.get_double_member("current_karma");
            karma_received(null, karma);
        } catch ( Error e ) {
            Error error = new Error(PLURK_ERROR_DOMAIN, PlurkError.JSON_PARSING_ERROR, "%d: %s", e.code, e.message);
            karma_received(error, 0.0);
        }
    }

    private void on_get_cliques_cb(Session session, Message msg) {
        string buffer = msg.response_body.flatten().data;
        try {
            Parser parser = new Parser();
            parser.load_from_data(buffer);
            unowned Json.Array array = parser.get_root().get_array();
            uint length = array.get_length();
            string[] cliques = new string[length];
            for ( int i = 0; i < length; i++ ) {
                cliques[i] = array.get_string_element(i).dup();
            }
            cliques_received(null, cliques);
        } catch ( Error e ) {
            Error error = new Error(PLURK_ERROR_DOMAIN, PlurkError.JSON_PARSING_ERROR, "%d: %s", e.code, e.message);
            cliques_received(error, new string[0]);
        }
    }

    private void on_get_clique_users_cb(Session session, Message msg) {
        string buffer = msg.response_body.flatten().data;
        HashTable<string, string> form_data = Soup.form_decode(msg.uri.query);
        string clique_name = form_data.lookup(PlurkApi.PARAM_CLIQUE_NAME);
        UserList users = new UserList.from_data(buffer);
        clique_users_received(null, clique_name, users);
    }

}
