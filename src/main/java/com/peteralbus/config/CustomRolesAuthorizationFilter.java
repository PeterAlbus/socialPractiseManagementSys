package com.peteralbus.config;

import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import org.apache.shiro.subject.Subject;
import org.apache.shiro.web.filter.authz.AuthorizationFilter;

/**
 * The type Custom roles authorization filter.
 * @author chen1218chen(csdn)
 */
public class CustomRolesAuthorizationFilter extends AuthorizationFilter
{
    @Override
    protected boolean isAccessAllowed(ServletRequest request,
                                      ServletResponse response, Object mappedValue) throws Exception
    {
        Subject subject = getSubject(request, response);
        String[] rolesArray = (String[]) mappedValue;

        if (rolesArray == null || rolesArray.length == 0)
        {
            return true;
        }
        for (String s : rolesArray)
        {
            if (subject.hasRole(s))
            {
                return true;
            }
        }
        return false;
    }
}
