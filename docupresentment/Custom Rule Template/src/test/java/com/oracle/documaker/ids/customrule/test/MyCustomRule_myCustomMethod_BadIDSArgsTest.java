package com.oracle.documaker.ids.customrule.test;

import com.docucorp.ids.data.IDSConstants;
import com.oracle.documaker.ids.customrule.MyCustomRule;
import org.junit.jupiter.api.MethodOrderer;
import org.junit.jupiter.api.Order;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.TestMethodOrder;

import static org.junit.jupiter.api.Assertions.assertEquals;

/**
 * In order to use these tests, you will need to modify the strings
 * to contain your database connection details, or source them
 * from some other component (e.g. a properties file)
 */
@TestMethodOrder(MethodOrderer.OrderAnnotation.class)
public class MyCustomRule_myCustomMethod_BadIDSArgsTest {

    static MyCustomRule idsRule = new MyCustomRule();
    static final String BADARGS = "db.user=baduser,db.password=badpass,db.url=dbc:db2://127.0.0.1:50000/mydb";
    // ----------------
    // Test Cases for Bad Arguments passed in from IDS.
    // ----------------

    @Test
    @Order(1)
    public void getEmployeesBadIdsArgsInit() throws Exception
    {
        System.out.println("getEmployeesBadIdsArgsInit");
        assertEquals(
                IDSConstants.RET_FAIL,
                idsRule.myCustomMethod(
                    null,
                        BADARGS,
                    IDSConstants.MSG_INIT
                )
        );
    }

    @Test
    @Order(2)
    public void getEmployeesBadIdsArgsForward()
    {
        System.out.println("getEmployeesBadIdsArgsForward");
        assertEquals(
                IDSConstants.RET_FAIL,
                idsRule.myCustomMethod(
                        null,
                        BADARGS,
                        IDSConstants.MSG_RUNF
                )
        );
    }

    @Test
    @Order(3)
    public void getEmployeesBadIdsArgsReverse()
    {
        System.out.println("getEmployeesBadIdsArgsReverse");
        assertEquals(
                IDSConstants.RET_SUCCESS,
                idsRule.myCustomMethod(
                        null,
                        BADARGS,
                        IDSConstants.MSG_RUNR
                )
        );
    }

    @Test
    @Order(4)
    public void getEmployeesBadIdsArgsTerm() throws Exception
    {
        System.out.println("getEmployeesBadIdsArgsTerm");
        assertEquals(
                IDSConstants.RET_SUCCESS,
                idsRule.myCustomMethod(
                        null,
                        BADARGS,
                        IDSConstants.MSG_TERM
                )
        );
    }
}
