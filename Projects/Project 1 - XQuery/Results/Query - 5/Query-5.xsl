<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">  
    <xsl:template match="/">
        <html>
            <body>
                <h2>Temporal Join.</h2>
                <table border="1">
                    <tr bgcolor="#9acd32">
                        <th style="text-align:center">Emp No</th>
                        <th style="text-align:center">Name</th>
                        <th style="text-align:center">Dept No</th>
                        <th style="text-align:center">Mgr No</th>
                        <th style="text-align:center">Longest Period</th>
                        <th style="text-align:left">Start date</th>
                        <th style="text-align:left">End date</th>
                    </tr>
                    <xsl:for-each select="temporalJoin/employee">
                        <tr>
                            <td><xsl:value-of select="empno"/></td>
                            <td><xsl:value-of select="name"/></td>
                            <td><xsl:value-of select="deptNo"/></td>
                            <td><xsl:value-of select="manager"/></td>
                            <td><xsl:value-of select="period/@period"/></td>
                            <td><xsl:value-of select="deptNo/@tstart"/></td>
                            <td><xsl:value-of select="deptNo/@tend"/></td>
                            
                        </tr>
                    </xsl:for-each>
                </table>
            </body>
        </html>
    </xsl:template>
</xsl:stylesheet>
