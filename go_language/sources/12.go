package main
import (
    "fmt"
    "database/sql"
    _ "github.com/Go-SQL-Driver/Mysql"    //这前面加上_编译的时候就不会忽略未使用而提示了
)
/**
 * 数据库操作
 * DB的主要方法有：
 * Query 执行数据库的Query操作， 例如一个select语句， 返回*Rows
 * QueryRow 执行数据库至多返回1行的Query操作，返回*Row
 * PrePare 准备一个数据库query操作， 返回一个*Stmt， 用于后续的query执行。 这个stmt可以被多次执行，或者并发执行
 * Exec执行数不返回任何rows的数据库语句 例如delete操作
 * Stmt的主要方法：
 * Exec
 * Query
 * QueryRow
 * Close
 * 用法与DB类似
 * Rows的主要方法：
 * Cloumns： 返回[]string, column names
 * Scan:
 * Next
 * Close
 *
 */
func main() {
    db, err := sql.Open("mysql", "root:123456@/test?charset=utf8")
    checkErr(err, "链接成功")
    //新增
    stmt, err := db.Prepare("INSERT INTO userinfo (uid, username, department, created) VALUES (?,?,?,?)");
    res, err  := stmt.Exec(nil, "ang", "Ang", "2014-12-30 00:00:03")
    checkErr(err, "插入成功")
    fmt.Println(res)
    //修改
    stmt, err = db.Prepare("UPDATE userinfo SET username=? where uid=?")
    res, err  = stmt.Exec("godeyeorg", 2)
    affect, err := res.RowsAffected()
    checkErr(err, "更新成功")
    fmt.Println(affect)
    //查询
    rows, err := db.Query("SELECT * FROM userinfo")
    for rows.Next() {
        var uid int
        var username, department, created string
        err = rows.Scan(&uid, &username, &department, &created)
        checkErr(err, "查询")
        fmt.Println(uid)
        fmt.Println(username)
        fmt.Println(department)
        fmt.Println(created)
    }

    //删除
    stmt, err = db.Prepare("DELETE FROM userinfo WHERE uid=?")
    res, err  = stmt.Exec(4)
    fmt.Println(res)

    db.Close()
}

func checkErr(err error, msg string) {
    if err != nil {
        panic(err)
    } else {
        fmt.Println(msg)
    }
}
