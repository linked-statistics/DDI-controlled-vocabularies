<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE rdf:RDF [
<!ENTITY skos           "http://www.w3.org/2004/02/skos/core#">
<!ENTITY rdf            "http://www.w3.org/1999/02/22-rdf-syntax-ns#">
<!ENTITY rdfs           "http://www.w3.org/2000/01/rdf-schema#">
<!ENTITY dcterms           "http://purl.org/dc/terms/">
<!ENTITY owl        "http://www.w3.org/2002/07/owl#">
<!ENTITY gc        "http://docs.oasis-open.org/codelist/ns/genericode/1.0/">
<!ENTITY ddi-cv        "urn:ddi-cv">
<!ENTITY h           "http://www.w3.org/1999/xhtml">
]>
    
    <!--    DDICV 2 SKOS, 2014-10-16
            by Benjamin Zapilko (benjamin.zapilko@gesis.org), GESIS
        
            This XSL transforms the current version of a DDI Controlled Vocabulary from Genericode XML to SKOS.
            The output file should be named as [ShortName]_[Version].rdf
            
            Last Update: 2014-10-16.
    -->
    
    
<xsl:stylesheet xmlns:dcterms="http://purl.org/dc/terms/"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsd="http://www.w3.org/2001/XMLSchema"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
    xmlns:skos="http://www.w3.org/2004/02/skos/core#"
    xmlns:owl="http://www.w3.org/2002/07/owl#"
    xmlns:gc="http://docs.oasis-open.org/codelist/ns/genericode/1.0/"
    xmlns:ddi-cv="urn:ddi-cv"
    xmlns:h="http://www.w3.org/1999/xhtml"
    version="2.0">
    <xsl:output method="xml" encoding="UTF-8" media-type="text/xml" indent="yes"/>
    <xsl:strip-space elements="*"/>
    
    <xsl:variable name="scheme">http://rdf-vocabulary.ddialliance.org/DDICV/</xsl:variable>
    <xsl:variable name="version"><xsl:value-of select="gc:CodeList/Identification/Version/."/></xsl:variable>
    <xsl:variable name="shortName"><xsl:value-of select="gc:CodeList/Identification/ShortName/."/></xsl:variable>
    
    <xsl:template match="/">
        <rdf:RDF xmlns:dcterms="&dcterms;" xmlns:skos="&skos;" xmlns:rdf="&rdf;" xmlns:rdfs="&rdfs;" xmlns:owl="&owl;">
            <xsl:apply-templates select="gc:CodeList"/>
        </rdf:RDF>
    </xsl:template>


<xsl:template match="gc:CodeList">
    
    <xsl:apply-templates select="Identification"/>
    
    <xsl:apply-templates select="SimpleCodeList"/>
    
</xsl:template>





<xsl:template match="Identification">

    <xsl:element name="rdf:Description">
        <xsl:attribute name="rdf:about">
            <xsl:value-of select="$scheme"/><xsl:value-of select="$shortName"/>_<xsl:value-of select="$version"/>#CodeList</xsl:attribute>
    <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#ConceptScheme"/>

<xsl:element name="dcterms:title">
    <xsl:attribute name="xml:lang">en</xsl:attribute>
    <xsl:value-of select="LongName"/>
</xsl:element>
    
  <xsl:element name="skos:notation">
     <xsl:value-of select="ShortName"/>
    </xsl:element>
    
    <xsl:element name="dcterms:description">
    <xsl:attribute name="xml:lang">en</xsl:attribute>
        <xsl:value-of select="../Annotation/Description/h:div[@class='Description']/."/>
    </xsl:element>
    
    <xsl:element name="dcterms:isVersionOf">
        <xsl:attribute name="rdf:resource"><xsl:value-of select="$scheme"/><xsl:value-of select="$shortName"/>#</xsl:attribute>
    </xsl:element>
  
    <xsl:element name="owl:versionInfo">
        <xsl:value-of select="$version"/>
    </xsl:element>
    
    <xsl:element name="dcterms:license">
        <xsl:attribute name="rdf:resource"><xsl:value-of select="../Annotation/AppInfo/ddi-cv:Value[@key='LicenseUrl']/."/></xsl:attribute>
    </xsl:element>
    
    <xsl:element name="dcterms:rights">
        <xsl:value-of select="../Annotation/AppInfo/ddi-cv:Value[@key='CopyrightText']/."/>&#160;<xsl:value-of select="../Annotation/AppInfo/ddi-cv:Value[@key='CopyrightOwner']/."/>&#160;<xsl:value-of select="../Annotation/AppInfo/ddi-cv:Value[@key='CopyrightYear']/."/>
    </xsl:element> 
        
     <xsl:for-each select="../SimpleCodeList/Row">  
        <xsl:element name="skos:hasTopConcept">
            <xsl:attribute name="rdf:resource"><xsl:value-of select="$scheme"/><xsl:value-of select="$shortName"/>_<xsl:value-of select="$version"/>#<xsl:value-of select="Value[@ColumnRef='Code']/SimpleValue/."/></xsl:attribute>
        </xsl:element>
     </xsl:for-each> 
        
    </xsl:element>

</xsl:template>



    <xsl:template match="SimpleCodeList">
 
        <xsl:for-each select="Row">
        
        <xsl:element name="rdf:Description">
            <xsl:attribute name="rdf:about">
                <xsl:value-of select="$scheme"/><xsl:value-of select="$shortName"/>_<xsl:value-of select="$version"/>#<xsl:value-of select="Value[@ColumnRef='Code']/SimpleValue/."/>
            </xsl:attribute>
            <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
            <xsl:element name="skos:inScheme">
                <xsl:attribute name="rdf:resource"><xsl:value-of select="$scheme"/><xsl:value-of select="$shortName"/>_<xsl:value-of select="$version"/>#CodeList</xsl:attribute>
            </xsl:element>
            <xsl:element name="skos:prefLabel">
                <xsl:attribute name="xml:lang">en</xsl:attribute>
                <xsl:value-of select="Value[@ColumnRef='Term']/ComplexValue/ddi-cv:Value/."/>
            </xsl:element>
            <xsl:element name="skos:notation">
                <xsl:value-of select="Value[@ColumnRef='Code']/SimpleValue/."/>
            </xsl:element>
            
            <xsl:if test="Value[@ColumnRef='Definition']/ComplexValue/ddi-cv:Value!=''">
            <xsl:element name="skos:definition">
                <xsl:attribute name="xml:lang">en</xsl:attribute>
                <xsl:value-of select="Value[@ColumnRef='Definition']/ComplexValue/ddi-cv:Value/."/>
            </xsl:element>
                </xsl:if>
        
        </xsl:element>
        
        </xsl:for-each>
        

    </xsl:template> 

  

</xsl:stylesheet>
