package de.blitzdose.webserver.auth;

import org.jdbi.v3.sqlobject.config.RegisterRowMapper;
import org.jdbi.v3.sqlobject.customizer.Bind;
import org.jdbi.v3.sqlobject.customizer.BindBean;
import org.jdbi.v3.sqlobject.statement.SqlQuery;
import org.jdbi.v3.sqlobject.statement.SqlUpdate;

import java.util.List;

public interface UserDao {
    @SqlUpdate("CREATE TABLE IF NOT EXISTS users (username TEXT PRIMARY KEY, password TEXT, totpSecret TEXT, superAdmin BOOLEAN DEFAULT FALSE, roleSets TEXT)")
    void createTable();

    @SqlUpdate("INSERT INTO users VALUES (:username, :password, :totpSecret, :superAdmin, :roleSets)")
    void insertUser(@BindBean User user);

    @SqlUpdate("UPDATE users SET password = :password, totpSecret = :totpSecret, superAdmin = :superAdmin, roleSets = :roleSets WHERE username = :username")
    void updateUser(@BindBean User user);

    @SqlQuery("SELECT username, password, totpSecret, superAdmin, roleSets FROM users WHERE username = :username")
    @RegisterRowMapper(UserMapper.class)
    User findByUsername(@Bind("username") String username);

    @SqlQuery("SELECT username, password, totpSecret, superAdmin, roleSets FROM users")
    @RegisterRowMapper(UserMapper.class)
    List<User> listAllUsers();

    @SqlUpdate("DELETE FROM users WHERE username = :username")
    void deleteByUsername(@Bind("username") String username);
}
