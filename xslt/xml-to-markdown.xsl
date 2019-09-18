<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:functx="http://www.functx.com"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" 
    expand-text="yes"
    version="3.0">
    
  <xsl:output method="xml" omit-xml-declaration="true" use-character-maps="gt"/>
  <xsl:strip-space elements="*" />

  <xsl:include href="mkdocs-x2y.xslt"/>
  <xsl:include href="inline.xslt"/>
  <xsl:include href="nav.xslt"/>
  <xsl:include href="documents.xslt"/>
  <xsl:include href="table.xslt"/>
  <xsl:include href="functions.xslt"/>
    
  <xsl:character-map name="gt">
    <xsl:output-character character="&gt;" string=">"/>
  </xsl:character-map>

  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="text()" priority="1">
    <xsl:value-of select="normalize-space(.)"/>
  </xsl:template>
  
  <xsl:param name="language" select="//mtc/@language"/>
  
  <!-- TODO: vol1 & vol2! -->
  <xsl:template match="/mtc/volume1">
    <!-- generate mkdocs.yml file -->
    <xsl:call-template name="mkdocs-cfg"/>
    
    <!-- generate markdown files -->
    <xsl:apply-templates/>
  </xsl:template>

  <!-- block elements -->
  
  <xsl:template match="revhistory/title">
    <xsl:text>**</xsl:text>
    <xsl:apply-templates/>
    <xsl:text>**: </xsl:text>
  </xsl:template>
  
  <xsl:template match="para[parent::revdescription][not(parent::footnote)]" priority="11">
    <xsl:if test="position()=1">
      <xsl:apply-templates select="ancestor::revhistory/title"/>
    </xsl:if>
    <xsl:apply-templates/>
    <xsl:text>&#xa;&#xa;</xsl:text> <!-- Block element -->
  </xsl:template>
  
  <xsl:template match="para[not(parent::footnote)]">
    <xsl:choose>
      <xsl:when test="parent::listitem[parent::itemizedlist]">
        <xsl:text>&#xa;&#xa;- </xsl:text>
        <xsl:apply-templates select="*|text()" />
        <xsl:text>&#xa;&#xa;</xsl:text> <!-- Block element -->
      </xsl:when>
      
      <xsl:when test="parent::listitem[parent::orderedlist]">
        <xsl:variable name="id" select="ancestor::para/@id"/>
        <xsl:variable name="item" select="count(parent::listitem[preceding-sibling::listitem])+1"/>
        <xsl:variable name="level">
          <xsl:choose>
            <xsl:when test="parent::listitem[parent::orderedlist[parent::listitem[parent::orderedlist]]]">2</xsl:when>
            <xsl:otherwise>1</xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        
        <xsl:if test="$item=1">
          <!-- ADD ID: Le if ci-dessous permet d'insérer l'id du paragraphe dans lequel l'ordelist est contenu  --> 
          <xsl:if test="parent::listitem[parent::orderedlist[parent::para[parent::article]]]">
            <xsl:text>&#xa;</xsl:text>
            <xsl:text expand-text="false">{: #</xsl:text>
            <xsl:value-of select="$id"/>
            <xsl:text expand-text="false"> }</xsl:text>
          </xsl:if>
          
          <xsl:text>&#xa;&#xa;</xsl:text>
        </xsl:if>
        
<!--    Below, no indentation with the CHOOSE code, the indentation is mandatory (or not) to define the level of the lists    -->

<xsl:choose>
<xsl:when test="$level=1">
1. <xsl:apply-templates select="*|text()" />
</xsl:when>
<xsl:when test="$level=2">
    1. <xsl:apply-templates select="*|text()" />
</xsl:when>
</xsl:choose>

        <xsl:text>&#xa;&#xa;</xsl:text> <!-- Block element -->
      </xsl:when>
      
      <xsl:when test="parent::version[ancestor::revhistory[ancestor::conventionmodel]]">
        <xsl:text>&#xa;&#xa;></xsl:text>
        <xsl:if test="@number">
          <xsl:variable name="number" select="replace(@number, '\.$', '\\.') || '  '"/>
          <xsl:value-of select="$number"/>
        </xsl:if>
        <xsl:apply-templates/>
        <xsl:text>&#xa;&#xa;</xsl:text> <!-- Block element -->
      </xsl:when>
      
      <xsl:otherwise>
        <xsl:variable name="id" select="@id"/>
        <xsl:if test="@number">
          <xsl:variable name="number" select="replace(@number, '\.$', '\\.') || '  '"/>
          <xsl:value-of select="$number"/>
        </xsl:if>
        <xsl:apply-templates/>
        
        <!--  Quand un paragraphe (avant History) contient une liste (orderedlist par exemple),
        on ne veut pas insérer l'id sous la liste. Dans ce cas, la liste sera insérée
        dans le template qui gère orderedlist (chercher le commentaire ADD ID)  -->

        <xsl:if test="not(child::orderedlist)">
          <xsl:text>&#xa;</xsl:text>
          <xsl:text expand-text="false">{: #</xsl:text>
          <xsl:value-of select="$id"/>
          <xsl:text expand-text="false"> }</xsl:text>
          <xsl:text>&#xa;&#xa;</xsl:text> <!-- Block element -->
        </xsl:if>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template match="
    introduction/title |
    conventionmodel/title |
    position/title">
    <xsl:text># </xsl:text>
    <xsl:apply-templates select="*|text()" />
    <xsl:text>&#xa;&#xa;</xsl:text> <!-- Block element -->  
  </xsl:template>

  <xsl:template match="section | article | revision | revdescription | orderedlist | listitem | version | preface | 
    para | emphasis | articleset | latin | foreignword | variation
    ">
    <xsl:apply-templates/>
  </xsl:template>
  
  <xsl:template match="revisionref">
    <xsl:text>&#xa;&#xa;</xsl:text>
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="introduction/section/title">
    <xsl:text># </xsl:text>
    <xsl:apply-templates select="concat(parent::section/@number, ' ', *|text())" />
    <xsl:text>&#xa;&#xa;</xsl:text> <!-- Block element -->
  </xsl:template>

  <xsl:template match="introduction/section/section/title">
    <xsl:text>## </xsl:text>
    <xsl:apply-templates select="*|text()" />
    <xsl:text>&#xa;&#xa;</xsl:text> <!-- Block element -->
  </xsl:template>
  
  <xsl:template match="introduction/section/section/section/title">
    <xsl:text>**</xsl:text>
    <xsl:apply-templates select="*|text()" />
    <xsl:text>**</xsl:text>
    <xsl:text>&#xa;&#xa;</xsl:text> <!-- Block element -->
  </xsl:template>
  
  <xsl:template match="conventionmodel/titleabbrev"/>
  
  <xsl:template match="conventionmodel/preface/title">
    <xsl:text>## </xsl:text>
    <xsl:apply-templates/>
    <xsl:text>&#xa;&#xa;</xsl:text> <!-- Block element -->
  </xsl:template>

  <xsl:template match="conventionmodel/preface/subtitle">
    <xsl:text>**</xsl:text>
      <xsl:apply-templates/>
    <xsl:text>**&#xa;&#xa;</xsl:text> <!-- Block element -->
  </xsl:template>
  
  <xsl:template match="conventionmodel/chapter/article/info/revhistory/revision/revdescription/para/version/title">
    <xsl:text>&#xa;&#xa;></xsl:text>
      <xsl:apply-templates/>
    <xsl:text>&#xa;&#xa;</xsl:text> <!-- Block element -->
  </xsl:template>

  <xsl:template match="chapter/title"/>
  
  <xsl:template match="article/title">
    <xsl:text>## </xsl:text>
    <xsl:value-of select="concat(parent::article/@titleabbrev, '. ')"/>
    <xsl:apply-templates select="*|text()" />
    <xsl:text>&#xa;&#xa;</xsl:text> <!-- Block element -->
  </xsl:template>
  
  <xsl:template match="info">
    <xsl:text>**</xsl:text>
      <xsl:value-of select="if ($language='en') then ('HISTORY') else ('HISTORIQUE')"/>
    <xsl:text>**&#xa;&#xa;</xsl:text> <!-- Block element -->
    <xsl:apply-templates/>
  </xsl:template>
  
  <xsl:template match="revhistory">
    <xsl:apply-templates select="* except title"/>
  </xsl:template>

  <xsl:template match="commentary/title">
    <xsl:apply-templates select="*|text()" />
    <xsl:text>&#xa;&#xa;</xsl:text> <!-- Block element -->  
  </xsl:template>
  
  <xsl:template match="commentary/section/title">
    <xsl:text>## </xsl:text>
    <xsl:if test="parent::section/@number">
      <xsl:value-of select="concat(parent::section/@number, ' ')" />
    </xsl:if>
    <xsl:apply-templates select="*|text()" />
    <xsl:text>&#xa;&#xa;</xsl:text> <!-- Block element -->
  </xsl:template>
  
</xsl:stylesheet>