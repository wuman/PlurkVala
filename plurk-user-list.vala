using Json;

public class Plurk.UserList : GLib.Object {

    private HashTable<string, User> user_by_id = new HashTable<string, User>(GLib.str_hash, GLib.str_equal);
    private List<User> user_list = new List<User>();

    /*
     * Constructors
     */
    public UserList() { }
    
    public UserList.from_data(string buffer) {
        this();
        Parser parser = new Parser();
        try {
            parser.load_from_data(buffer);

            build(parser.get_root());
        } catch ( Error e) {
            stdout.printf("Error: %s\n", e.message);
        }
    }

    public UserList.from_node(Json.Node node) {
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
        user_by_id = new HashTable<string, User>(GLib.str_hash, GLib.str_equal);
        user_list = new List<User>();
    }

    private void build(Json.Node node) {
        if ( node.get_node_type() != NodeType.OBJECT && node.get_node_type() != NodeType.ARRAY ) {
            return;
        }

        if ( node.get_node_type() == NodeType.OBJECT ) {
            Json.Object object = node.get_object();
            /*
            List<string> mnames = object.get_members();
            foreach ( string name in mnames ) {
                unowned Json.Node user_node = object.get_member(name);
                User user = new User.from_node(user_node);
                user_by_id.replace(name, (User) user.ref_sink());
                user_list.prepend(user);
            }
            */
            object.foreach_member(build_user);
            user_list.reverse();
        } else if ( node.get_node_type() == NodeType.ARRAY ) {
            foreach ( unowned Json.Node user_node in node.get_array().get_elements() ) {
                User user = new User.from_node(user_node);
                user_by_id.replace(user.user_id, (User) user.ref_sink());
                user_list.prepend(user);
            }
            user_list.reverse();
        }
    }

    public void build_user(Json.Object object, string member_name, Json.Node member_node) {
        User user = new User.from_node(member_node);
        user_by_id.replace(member_name, (User) user.ref_sink());
        user_list.prepend(user);
    }

    public uint get_count() {
        return user_by_id.size();
    }

    public User get_id(string user_id) {
        return user_by_id.lookup(user_id);
    }

    public User get_pos(uint index) {
        if ( index >= 0 ) {
            return user_list.nth_data(index);
        } else {
            uint roll = user_list.length();
            roll += index;
            return user_list.nth_data(roll);
        }
    }

    public List<User> get_all() {
        return user_list.copy();
    }

}
