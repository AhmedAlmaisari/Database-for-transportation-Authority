#include <stdlib.h>
#include <iostream>

#include "mysql_connection.h"

#include <cppconn/driver.h>
#include <cppconn/exception.h>
#include <cppconn/resultset.h>
#include <cppconn/statement.h>

using namespace std;

int main(void)
{
    cout << endl;

    try {
        sql::Driver* driver;
        sql::Connection* con;
        sql::Statement* stmt;
        sql::ResultSet* res;

        string area;

        /* Create a connection */
        driver = get_driver_instance();
        con = driver->connect("tcp://127.0.0.1:3306", "root", "123123123");
        /* Connect to the MySQL test database */
        con->setSchema("transportationauthority");

        cout << "Enter area name: ";
        cin >> area;

        stmt = con->createStatement();
        res = stmt->executeQuery("SELECT DISTINCT Route.RouteName FROM Route JOIN Bus_Stops ON Route.RouteID = Bus_Stops.RouteID WHERE Bus_Stops.stopName LIKE '%" + area + "%'");
        cout << "\t... MySQL replies: ";
        while (res->next()) {
            cout << res->getString("RouteName") << endl;
        }
        delete res;
        delete stmt;
        delete con;

    }
    catch (sql::SQLException& e) {
        cout << "# ERR: SQLException in " << _FILE_;
        cout << "# ERR: " << e.what();
        cout << " (MySQL error code: " << e.getErrorCode();
        cout << ", SQLState: " << e.getSQLState() << " )" << endl;
    }

    cout << endl;

    return EXIT_SUCCESS;
}