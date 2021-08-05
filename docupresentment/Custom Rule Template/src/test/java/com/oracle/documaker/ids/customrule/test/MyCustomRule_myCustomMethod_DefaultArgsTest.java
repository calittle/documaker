package com.oracle.documaker.ids.customrule.test;

import com.oracle.documaker.ids.customrule.MyCustomRule;

import com.docucorp.ids.data.IDSConstants;

import org.junit.jupiter.api.*;

import static org.junit.jupiter.api.Assertions.assertEquals;

/**
 * In order to use these tests, you will need to modify the strings
 * to contain your database connection details, or source them
 * from some other component (e.g. a properties file)
 */
@TestMethodOrder(MethodOrderer.OrderAnnotation.class)
public class MyCustomRule_myCustomMethod_DefaultArgsTest {
    private static final String idsArgs = "";
    static MyCustomRule idsRule = new MyCustomRule();

    // ----------------
    // Test Cases for defaults from properties file.
    // ----------------
    @Test
    @Order(1)
    public void getEmployeesDefaultPropertiesInit() throws Exception
    {
        System.out.println("getEmployeesDefaultPropertiesInit");
        idsRule.myCustomMethod(
                null,
                idsArgs,
                IDSConstants.MSG_INIT
        );
    }

    @Test
    @Order(2)
    public void getEmployeesDefaultPropertiesForward()
    {
        System.out.println("getEmployeesDefaultPropertiesForward");
        assertEquals(
                IDSConstants.RET_SUCCESS,
                idsRule.myCustomMethod(
                        null,
                        idsArgs,
                        IDSConstants.MSG_RUNF
                )
        );
    }

    @Test
    @Order(3)
    public void getEmployeesDefaultPropertiesReverse()
    {
        System.out.println("getEmployeesDefaultPropertiesReverse");
        assertEquals(
                IDSConstants.RET_SUCCESS,
                idsRule.myCustomMethod(
                        null,
                        idsArgs,
                        IDSConstants.MSG_RUNR
                )
        );
    }

    @Test
    @Order(4)
    public void getEmployeesDefaultPropertiesTerm() throws Exception
    {
        System.out.println("getEmployeesDefaultPropertiesTerm");
        idsRule.myCustomMethod(
                null,
                idsArgs,
                IDSConstants.MSG_TERM
        );
    }

}
