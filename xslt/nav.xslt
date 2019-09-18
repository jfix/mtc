<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    expand-text="yes"
    xmlns:l="http://local"
    xmlns:functx="http://www.functx.com"
    version="3.0">

    <!-- This file generates the nav section that 
         gets added to the mkdocs.yml file. -->
    
    <xsl:variable name="mkdocs.config.root" select="document('../mkdocs.xml')/config"/>
    
    <xsl:template name="mkdocs-cfg">
        <xsl:variable name="cfg">
            <xsl:apply-templates select="$mkdocs.config.root"/>
        </xsl:variable>
        
        <xsl:variable name="nav" as="element(nav)">
            <nav>
                <xsl:text>nav:&#xa;</xsl:text>
                <xsl:text>  - 'Volume I':&#xa;</xsl:text>
                <xsl:apply-templates mode="nav" select="* except title"/>
            </nav>
        </xsl:variable>
        
        <xsl:result-document href="../mkdocs.yml">
            <xsl:value-of select="$cfg"/>
            <xsl:value-of select="$nav/text()"/>
        </xsl:result-document>
    </xsl:template>
    
    <!-- ================================= -->
    <!--          INTRODUCTION             -->
    <!-- ================================= -->
    <xsl:template match="volume1/introduction" mode="nav">
        <xsl:value-of select="functx:repeat-string('  ', 2)"/>
        <xsl:text>- 'Introduction':&#xa;</xsl:text>
        <xsl:value-of select="functx:repeat-string('  ', 3)"/>
        <xsl:text>- 'Introduction': 'vol1/introduction/index.md'&#xa;</xsl:text>
        <xsl:apply-templates select="section" mode="nav"/>
    </xsl:template>
    
    <xsl:template match="volume1/introduction/section" mode="nav">
        <xsl:value-of select="functx:repeat-string('  ', 3)"/>
        <xsl:value-of>{"- '" || @number || " " || normalize-space(title) || "': "}</xsl:value-of>
        <xsl:value-of>{"'vol1/introduction/" || @id || ".md'&#xa;"}</xsl:value-of>
    </xsl:template>

    <!-- ================================= -->
    <!--          CONVENTIONMODEL          -->
    <!-- ================================= -->
    <xsl:template match="conventionmodel" mode="nav">
        <xsl:value-of select="functx:repeat-string('  ', 2)"/>
        <xsl:text>- 'Model Convention':&#xa;</xsl:text>
        <xsl:value-of select="functx:repeat-string('  ', 3)"/>
        <xsl:text>- 'Title and Preamble':  'vol1/conventionmodel/index.md'&#xa;</xsl:text>
        <xsl:apply-templates select="chapter" mode="nav"/>
    </xsl:template>
    
    <xsl:template match="conventionmodel/chapter" mode="nav">
        <xsl:variable name="lctitle" select="lower-case(title)"/>
        <xsl:variable name="title" select="l:uppercase-some-words($lctitle)"/>
        <xsl:value-of select="functx:repeat-string('  ', 3)"/>
        <xsl:value-of>{"- '" || @titleabbrev || " - " || upper-case(substring($title, 1, 1)) || substring($title, 2) || "':&#xa;"}</xsl:value-of>
        <xsl:apply-templates select="article" mode="nav"/>
        <xsl:apply-templates select="articleset" mode="nav"/>
    </xsl:template>
    
    <xsl:template match="conventionmodel/chapter/article" mode="nav">
        <xsl:variable name="lctitle" select="lower-case(./title/text())"/>
        <xsl:variable name="title" select="normalize-space(l:uppercase-some-words($lctitle))"/>
        <xsl:value-of select="functx:repeat-string('  ', 4)"/>
        <xsl:value-of>{"- '" || @titleabbrev || " - " || upper-case(substring($title, 1, 1)) || substring($title, 2) || "': "}</xsl:value-of>
        <xsl:value-of>{"'vol1/conventionmodel/" || parent::chapter/@id || '/' || @id || ".md'&#xa;"}</xsl:value-of>
    </xsl:template>
    
    <xsl:template match="conventionmodel/chapter/articleset/article" mode="nav">
        <xsl:variable name="lctitle" select="lower-case(./title/text())"/>
        <xsl:variable name="title" select="normalize-space(l:uppercase-some-words($lctitle))"/>
        <xsl:value-of select="functx:repeat-string('  ', 4)"/>
        <xsl:value-of>{"- '" || @titleabbrev || " - " || upper-case(substring($title, 1, 1)) || substring($title, 2) || "': "}</xsl:value-of>
        <xsl:value-of>{"'vol1/conventionmodel/" || ancestor::chapter/@id || '/' || @id || ".md'&#xa;"}</xsl:value-of>
    </xsl:template>
    
    <xsl:function name="l:uppercase-some-words" as="xs:string">
        <xsl:param name="input" as="xs:string"/>
        <xsl:value-of select="
            replace(replace(replace(replace(replace(replace($input, 
                'convention', 'Convention'),
                'income', 'Income'), 
                'capital', 'Capital'),
                'taxation', 'Taxation'),
                'elimination', 'Elimination'),
                'provisions', 'Provisions')
        "/>        
    </xsl:function>
    
    <!-- ================================= -->
    <!--          COMMENTARIES             -->
    <!-- ================================= -->
    <xsl:template match="commentaries" mode="nav">
        <xsl:value-of select="functx:repeat-string('  ', 2)"/>
        <xsl:text>- 'Commentaries':&#xa;</xsl:text>
        <xsl:apply-templates select="commentary" mode="nav"/>
    </xsl:template>
    
    <xsl:template match="commentary" mode="nav">
        <xsl:value-of select="functx:repeat-string('  ', 3)"/>
        <xsl:value-of>{"- '" || @titleabbrev || "': "}</xsl:value-of>
        <xsl:value-of>{"'vol1/commentaries/" || @id || ".md'&#xa;"}</xsl:value-of>
    </xsl:template>
    
    <!-- ================================= -->
    <!--          POSITIONS                -->
    <!-- ================================= -->
    <xsl:template match="positions" mode="nav">
        <xsl:value-of select="functx:repeat-string('  ', 2)"/>
        <xsl:text>- 'Non-Member Countries Positions':&#xa;</xsl:text>
        <xsl:value-of select="functx:repeat-string('  ', 3)"/>
        <xsl:text>- 'Introduction':  'vol1/positions/index.md'&#xa;</xsl:text>
        <xsl:apply-templates select="position" mode="nav"/>
    </xsl:template>
    
    <xsl:template match="position" mode="nav">
        <xsl:value-of select="functx:repeat-string('  ', 3)"/>
        <xsl:value-of>{"- '" || @titleabbrev || "': "}</xsl:value-of>
        <xsl:value-of>{"'vol1/positions/" || @id || ".md'&#xa;"}</xsl:value-of>
    </xsl:template>
    
    
    
</xsl:stylesheet>