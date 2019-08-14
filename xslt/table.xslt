<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="3.0">
    
    <xsl:template match="table">
        <xsl:message>Hello, TABLE !!!!!</xsl:message>
        <xsl:text>&#xa;&#xa;</xsl:text> <!-- Block element -->
        <table>
            <xsl:apply-templates/>
        </table>
        <xsl:text>&#xa;&#xa;</xsl:text> <!-- Block element -->    </xsl:template>
    
    <xsl:template match="tblgroup">
        <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template match="colspan">
        <!-- ignoring this for the time being -->    
    </xsl:template>
    
    <xsl:template match="tableheading">
        <xsl:variable name="nb-column">
            <xsl:choose>
                <xsl:when test="ancestor::tablegrp/table/tgroup/@cols">
                    <xsl:value-of select="max(ancestor::tablegrp/table/tgroup/@cols)"/>
                </xsl:when>
                <xsl:otherwise>1</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <tbody class="web-art_group-heading">
            <tr>
                <th colspan="{$nb-column}">
                    <xsl:apply-templates/>
                </th>
            </tr>
        </tbody>
    </xsl:template>
    
    <xsl:template match="tablesubheading">
        <xsl:variable name="nb-column">
            <xsl:choose>
                <xsl:when test="ancestor::tablegrp/table/tgroup/@cols">
                    <xsl:value-of select="max(ancestor::tablegrp/table/tgroup/@cols)"/>
                </xsl:when>
                <xsl:otherwise>1</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <tbody class="web-art_group-subheading">
            <tr>
                <th colspan="{$nb-column}">
                    <xsl:apply-templates/>
                </th>
            </tr>
        </tbody>
    </xsl:template>
    
    <xsl:template match="tablemainhead">
        <xsl:choose>
            <xsl:when test="parent::tableheading">
                <xsl:variable name="context" select="ancestor::tablegrp"/>
                <div class="web-art_table-heading">
                    <xsl:apply-templates/>
                </div>
            </xsl:when>
            <xsl:when test="parent::tablesubheading">
                <div class="web-art_table-subheading">
                    <xsl:apply-templates/>
                </div>
            </xsl:when>
            <xsl:otherwise>
                <xsl:message terminate="no">
                    <xsl:text>No processing provided for Element : </xsl:text>
                    <xsl:value-of select="parent::*/name()"/>
                    <xsl:text>. Please control the XML flow.</xsl:text>
                </xsl:message>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="thead">
        <tbody>
            <xsl:apply-templates/>
        </tbody>
    </xsl:template>
    
    <xsl:template match="tbody">
        <tbody>
            <xsl:apply-templates/>
        </tbody>
    </xsl:template>
    
    <!-- Table rows -->
    <xsl:template match="row">
        <tr>
            <xsl:apply-templates/>
        </tr>
    </xsl:template>
    
    <!-- Table cells -->
    <xsl:template match="entry">
        <xsl:variable name="name-cell-element">
            <xsl:choose>
                <xsl:when test="ancestor::thead">
                    <xsl:value-of select="'th'"/>
                </xsl:when>
                <xsl:when test="ancestor::tbody">
                    <xsl:value-of select="'td'"/>
                </xsl:when>
            </xsl:choose>
        </xsl:variable>
        <xsl:element name="{$name-cell-element}">
            <xsl:if test="@morerows">
                <xsl:attribute name="rowspan" select="@morerows+1"/>
            </xsl:if>
            <xsl:if test="@nameend">
                <xsl:attribute name="colspan">
                    <xsl:choose>
                        <xsl:when test="ancestor::tgroup/colspec">
                            <xsl:if test="@nameend">
                                <xsl:variable name="nameend" select="@nameend"/>
                                <xsl:variable name="namest" select="@namest"/>
                                <xsl:value-of select="(count(ancestor::tgroup/colspec[@colname=$nameend]/preceding-sibling::colspec)+1)-(count(ancestor::tgroup/colspec[@colname=$namest]/preceding-sibling::colspec)+1)+1"/>
                            </xsl:if>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of
                                select="if(@nameend) then(number(@nameend)-number(@namest)+1) else('1')"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:attribute>
            </xsl:if>
            <xsl:choose>
                <xsl:when test="@valign">
                    <xsl:attribute name="class" select="concat('web-art_',@valign)"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:attribute name="class" select="'web-art_top'"/>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    
    <!-- Table note -->
    <xsl:template match="tabnote">
        <tbody>
            <tr>
                <td colspan="{preceding-sibling::table/tgroup/@cols}">
                    <xsl:apply-templates/>
                </td>
            </tr>
        </tbody>
    </xsl:template>
    
    <xsl:template match="tablegrp/source">
        <tbody class="group-tfoot">
            <tr>
                <td colspan="{preceding-sibling::table/tgroup/@cols}">
                    <xsl:apply-templates/>
                </td>
            </tr>
        </tbody>
    </xsl:template>
    
    
    
</xsl:stylesheet>