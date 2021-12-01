<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE xsl:stylesheet [
  <!ENTITY nbsp "&#x00A0;">
]>
<xsl:stylesheet
	version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:msxml="urn:schemas-microsoft-com:xslt"
	xmlns:umbraco.library="urn:umbraco.library"
  xmlns:Exslt.ExsltCommon="urn:Exslt.ExsltCommon"
  xmlns:Exslt.ExsltDatesAndTimes="urn:Exslt.ExsltDatesAndTimes"
  xmlns:Exslt.ExsltMath="urn:Exslt.ExsltMath"
  xmlns:Exslt.ExsltRegularExpressions="urn:Exslt.ExsltRegularExpressions"
  xmlns:Exslt.ExsltStrings="urn:Exslt.ExsltStrings"
  xmlns:Exslt.ExsltSets="urn:Exslt.ExsltSets"
  xmlns:ps="urn:ps"
	exclude-result-prefixes="msxml umbraco.library Exslt.ExsltCommon Exslt.ExsltDatesAndTimes Exslt.ExsltMath Exslt.ExsltRegularExpressions Exslt.ExsltStrings Exslt.ExsltSets ps">

  <xsl:output method="xml" omit-xml-declaration="yes"/>

  <xsl:param name="currentPage"/>

  <!-- "global" variables -->
  <xsl:variable name="currentID" select="$currentPage/@id"/>

  <!-- MACRO parameters get default values if not passed in from the macro -->
  <xsl:variable name="resultsPerPage" select="string('10')"/>
  <xsl:variable name="previewChars" select="string('255')"/>
  <xsl:variable name="previewType" select="ps:uppercase('beginning')"/>
  <!-- valid choices are: 'beginning' and 'context' -->

  <!-- which umbraco fields to search -->
  <!-- Note: Comma-separated list of fields. The order of the search fields affects the search score and
       order of the search results! Place the more important fields first, with bodyText last. 
       The reason is that if a search term appears in the page's title, there is a greater likelihood 
       that page discusses the search term at length, than it simply being mentioned in the bodyText in passing. 
  -->
  <xsl:variable name="searchFields" select="ps:getListParameter(string(//macro/searchFields), '@nodeName,SEOTitle,metaKeywords,metaDescription,IntroText,bodyText')"/>

  <!-- which umbraco field to display for a found entry -->
  <!-- Note: Comma-separated list of fields. The order of the preview fields is from most preferred 
       to least preferred. Put the most appropriate fields first (typically, bodyText).
       Note: ONLY works for properties, not attributes  
  -->
  <xsl:variable name="previewFields" select="ps:getListParameter(string(//macro/previewFields), 'IntroText,bodyText')"/>



  <!-- the search term to look for -->
  <xsl:variable name="search">
    <xsl:choose>
      <!-- querystring value, if present -->
      <xsl:when test="string(umbraco.library:RequestQueryString('search')) != ''">
        <xsl:value-of select="ps:escapeSearchTerms(string(umbraco.library:RequestQueryString('search')))" />
      </xsl:when>
      <!-- form field value, if present -->
      <xsl:when test="string(umbraco.library:RequestForm('search')) != ''">
        <xsl:value-of select="ps:escapeSearchTerms(string(umbraco.library:RequestForm('search')))" />
      </xsl:when>
      <!-- no value -->
      <xsl:otherwise>
        <xsl:value-of select="''"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:variable name="unescapedSearch" select="ps:unescapeSearchTerms($search)"/>




  <!-- We have to calculate matching nodes before we can finish calculating the rest of the variables/parameters... -->
  <!-- uppercase the search string for case-insensitive searching -->
  <xsl:variable name="searchUpper" select="ps:uppercase(string($search))"/>

  <xsl:template match="/">
    <xsl:choose>
      <!-- short-circuit the whole searching if no search-text were passed in -->
      <xsl:when test="$search = ''">
        <!-- using NO nodes; only calling the template for the form -->
        <xsl:call-template name="search">
          <xsl:with-param name="items" select="./node[1=2]"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <!-- using ALL nodes -->
        <xsl:call-template name="search">
          <xsl:with-param name="items" select="umbraco.library:GetXmlAll()"/>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>

  </xsl:template>

  <!-- Perform the search on the appropriate nodeset and display the output -->
  <xsl:template name="search">
    <xsl:param name="items"/>

    <!-- reduce the number of nodes for applying all the functions in the next step -->
    <xsl:variable name="possibleNodes" select="$items/descendant-or-self::node[
                                               string(data [@alias='umbracoNaviHide']) != '1'
                                               and count(attribute::id)=1 
                                               and (umbraco.library:IsProtected(@id, @path) = false()
                                                    or umbraco.library:HasAccess(@id, @path) = true())
                                               and string(data [@alias='ExcludeFromSearch']) != '1'
                                               and (@nodeTypeAlias='BlogPost')
                                               ]"/>


    <!-- generate a string of a semicolon-delimited list of all @id's of the matching nodes -->
    <xsl:variable name="matchedNodesIdList">
      <xsl:call-template name="booleanAndMatchedNodes">
        <xsl:with-param name="yetPossibleNodes" select="$possibleNodes"/>
        <xsl:with-param name="searchTermList" select="concat($searchUpper, ' ')"/>
      </xsl:call-template>
    </xsl:variable>

    <!-- get the actual matching nodes as a nodeset -->
    <xsl:variable name="matchedNodes" select="$possibleNodes[contains($matchedNodesIdList, concat(';', concat(@id, ';')))]" />
    <xsl:choose>
      <xsl:when test="count($matchedNodes) = 0">
        <h2>No results found</h2>
      </xsl:when>
      <xsl:otherwise>
        <h2>Search results for <xsl:value-of select="$unescapedSearch"/>
      </h2>
      </xsl:otherwise>
    </xsl:choose>

    <!-- the current page -->
    <xsl:variable name="page">
      <xsl:choose>
        <!-- first page -->
        <xsl:when test="number(umbraco.library:RequestQueryString('page')) &lt;=1 or string(umbraco.library:RequestQueryString('page')) = '' or string(number(umbraco.library:RequestQueryString('page'))) = 'NaN'">
          1
        </xsl:when>
        <!-- last page -->
        <xsl:when test="number(umbraco.library:RequestQueryString('page')) &gt; count($matchedNodes) div $resultsPerPage">
          <xsl:value-of select="ceiling(count($matchedNodes) div $resultsPerPage)"/>
        </xsl:when>
        <!-- the value specified in the macro -->
        <xsl:otherwise>
          <xsl:value-of select="number(umbraco.library:RequestQueryString('page'))"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <!-- calculate a few handy variables now, for easy access later -->
    <xsl:variable name="startMatch" select="($page - 1) * $resultsPerPage + 1"/>
    <xsl:variable name="endMatch">
      <xsl:choose>
        <!-- all the rest (on the last page) -->
        <xsl:when test="($page * $resultsPerPage) &gt; count($matchedNodes)">
          <xsl:value-of select="count($matchedNodes)"/>
        </xsl:when>
        <!-- only the appropriate number for this page -->
        <xsl:otherwise>
          <xsl:value-of select="$page * $resultsPerPage"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:if test="count($matchedNodes) > 0">
      <!-- display results header information to the screen, if a search has been run; otherwise just show the search form -->
      <div class="blogListItem">
        <xsl:if test="$unescapedSearch !=''">
          <!-- Now we need to sort the pages by score/relevance before sending them to the screen. 
               We'll cycle through matched nodes once to save their pageScore in a variable -->
          <xsl:variable name="pageScoreList">
            <xsl:text>;</xsl:text>
            <xsl:for-each select="$matchedNodes">
              <!-- unique id for this node -->
              <xsl:value-of select="generate-id(.)"/>
              <xsl:text>=</xsl:text>
              <!-- weighted score for the matches -->
              <xsl:call-template name="pageScore">
                <xsl:with-param name="item" select="."/>
              </xsl:call-template>
              <xsl:text>;</xsl:text>
            </xsl:for-each>
          </xsl:variable>

          <!-- display search results to the screen -->
          <xsl:for-each select="$matchedNodes">
            <!-- sort on the page score of the node, within ALL the nodes to return (the sorting must happen before choosing the nodes for this page) -->
            <xsl:sort select="substring-before(substring-after($pageScoreList, concat(';',generate-id(.),'=')),';')" data-type="number" order="descending"/>

            <!-- only the nodes for this page -->
            <xsl:variable name="displayField">
              <xsl:call-template name="displayFieldText">
                <xsl:with-param name="item" select="."/>
                <xsl:with-param name="fieldList" select="$previewFields"/>
              </xsl:call-template>
            </xsl:variable>

            <!-- contents of search result -->
            <xsl:variable name="strippedHTML" select="umbraco.library:StripHtml($displayField)"/>

            <xsl:variable name="escapedData">
              <xsl:choose>
                <!-- display content of the search result, if available -->
                <xsl:when test="string($strippedHTML) != ''">
                  <xsl:value-of select="$strippedHTML"/>
                </xsl:when>
              </xsl:choose>
            </xsl:variable>


            <!-- prepare for highlighting the search term within the search results by surrounding it with 'strong' tags -->
            <xsl:variable name="before">&lt;strong&gt;</xsl:variable>
            <xsl:variable name="after">&lt;/strong&gt;</xsl:variable>

            <h2>
              <a href="{umbraco.library:NiceUrl(@id)}">
                <xsl:value-of select="@nodeName"/>
              </a>
            </h2>
            <p>
              <span class="date">
                By <xsl:value-of select="umbraco.library:GetXmlNodeById(data[@alias='Author'])/@nodeName"/> -
                <xsl:value-of select="ps:GetFormattedDate(data[@alias='Date'])"/>
              </span>
              <br />
              <xsl:if test="data[@alias='Image'] != ''">
                <img class="blogThumb" alt="{@nodeName}" src="{data[@alias='Image']}" />
              </xsl:if>
              <xsl:value-of select="data[@alias='IntroText']"/>
              <br />
              <a href="{umbraco.library:NiceUrl(@id)}">read article</a>
              <div class="clearer">&nbsp;</div>
            </p>
            <div class="hr">&nbsp;</div>
            <!-- OPTIONAL: include any additional information regarding the search result you want to display, such as createDate, updateDate, author, etc. -->

          </xsl:for-each>
        </xsl:if>
        <xsl:value-of select="''"/>

      </div>
    </xsl:if>

  </xsl:template>




  <xsl:template name="pageScore">
    <xsl:param name="item"/>

    <!-- sum up scores for each of the attributes -->
    <xsl:variable name="scoreA">
      <xsl:call-template name="scoreAttributes">
        <xsl:with-param name="item" select="$item"/>
      </xsl:call-template>
    </xsl:variable>

    <!-- sum up scores for each of the data nodes -->
    <xsl:variable name="scoreD">
      <xsl:call-template name="scoreDataNodes">
        <xsl:with-param name="item" select="$item/data[contains($searchFields, concat(',',@alias,','))]"/>
      </xsl:call-template>
    </xsl:variable>

    <xsl:value-of select="number($scoreA) + number($scoreD)"/>
  </xsl:template>

  <xsl:template name="scoreAttributes">
    <xsl:param name="item"/>
    <xsl:param name="index" select="1"/>
    <xsl:param name="score" select="0"/>

    <!-- name of the attribute on which we're searching -->
    <xsl:variable name="attributeName" select="name($item/attribute::*[position()=$index])"/>

    <xsl:variable name="weighting">
      <xsl:if test="contains($searchFields, concat(',@',$attributeName,','))">
        <xsl:value-of select="ps:power(2, number(ps:hitCount(substring-after($searchFields,$attributeName), ','))-1)"/>
      </xsl:if>
    </xsl:variable>


    <!-- calculate the final, cumulative, weighted score for this field -->
    <xsl:variable name="thisScore">
      <xsl:choose>
        <xsl:when test="contains($searchFields, concat(',@',$attributeName,','))">
          <!-- only calculate when this is a field actually being searched -->
          <xsl:call-template name="scoreForBooleanSearch">
            <xsl:with-param name="weighting" select="$weighting"/>
            <xsl:with-param name="toSearch" select="umbraco.library:StripHtml(string($item/attribute::*[name()=$attributeName]))"/>
            <xsl:with-param name="searchTermList" select="concat($search, ' ')"/>
          </xsl:call-template>
        </xsl:when>
        <xsl:otherwise>0</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>


    <xsl:choose>
      <xsl:when test="count(./attribute::*)=$index">
        <!-- all done; print out total weight score -->
        <xsl:value-of select="$score + $thisScore"/>
      </xsl:when>
      <xsl:otherwise>
        <!-- continue recursion for other fields -->
        <xsl:call-template name="scoreAttributes">
          <xsl:with-param name="item" select="$item"/>
          <xsl:with-param name="index" select="$index + 1"/>
          <xsl:with-param name="score" select="$score + $thisScore"/>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>

  </xsl:template>

  <xsl:template name="scoreForBooleanSearch">
    <xsl:param name="weighting" select="1"/>
    <xsl:param name="toSearch"/>
    <xsl:param name="searchTermList"/>
    <xsl:param name="currentHitCount" select="0"/>

    <!-- next search term -->
    <xsl:variable name="searchTerm">
      <xsl:value-of select="ps:getFirstElement($searchTermList, ' ')"/>
    </xsl:variable>

    <!-- remaining search terms -->
    <xsl:variable name="remainingSearchTermList">
      <xsl:value-of select="ps:removeFirstElement($searchTermList, ' ')"/>
    </xsl:variable>

    <!-- hit count for this search term -->
    <xsl:variable name="thisHitCount">
      <xsl:value-of select="ps:hitCount($toSearch, string($searchTerm))"/>
    </xsl:variable>

    <xsl:choose>
      <xsl:when test="string-length($remainingSearchTermList) &gt; 1">
        <!-- continue to search the rest of the terms -->
        <xsl:call-template name="scoreForBooleanSearch">
          <xsl:with-param name="weighting" select="$weighting"/>
          <xsl:with-param name="toSearch" select="$toSearch"/>
          <xsl:with-param name="searchTermList" select="$remainingSearchTermList"/>
          <xsl:with-param name="currentHitCount" select="$currentHitCount + $thisHitCount"/>
        </xsl:call-template>
      </xsl:when>

      <xsl:otherwise>
        <!-- finished searching: return the total hit count * weighting -->
        <xsl:value-of select="number($currentHitCount + $thisHitCount) * $weighting"/>
      </xsl:otherwise>
    </xsl:choose>

  </xsl:template>

  <xsl:template name="scoreDataNodes">
    <xsl:param name="item"/>
    <xsl:param name="score" select="0"/>

    <!-- the weighting to apply to hits in this search field -->
    <xsl:variable name="weighting" select="ps:power(2, number(ps:hitCount(substring-after($searchFields,string($item/@alias)), ','))-1)"/>

    <!-- calculate the final, cumulative, weighted score for this field -->
    <xsl:variable name="thisScore">
      <xsl:choose>
        <xsl:when test="contains($searchFields, concat(',',$item/@alias,','))">
          <!-- only calculate when this is a field actually being searched -->
          <xsl:call-template name="scoreForBooleanSearch">
            <xsl:with-param name="weighting" select="$weighting"/>
            <xsl:with-param name="toSearch" select="umbraco.library:StripHtml(string($item))"/>
            <xsl:with-param name="searchTermList" select="concat($search, ' ')"/>
          </xsl:call-template>
        </xsl:when>
        <xsl:otherwise>0</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <!-- remaining data nodes whose hitCounts we need to tally; for recursion use -->
    <xsl:variable name="remaining" select="$item/following-sibling::data[contains($searchFields, concat(',',@alias,','))]"/>
    <xsl:choose>
      <xsl:when test="count($remaining) = 0">
        <!-- all done; return the final score -->
        <xsl:value-of select="number($thisScore) + number($score)"/>
      </xsl:when>
      <xsl:otherwise>
        <!-- keep summing the hitCounts for all the fields for this page by calling the pageScore template recursively -->
        <xsl:call-template name="scoreDataNodes">
          <xsl:with-param name="item" select="$remaining[position()=1]"/>
          <xsl:with-param name="score" select="number($thisScore) + number($score)"/>
          <!--<xsl:with-param name="loopIndex" select="$loopIndex + 1"/>-->
        </xsl:call-template>
        <!--</xsl:if>-->
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>


  <xsl:template name="displayFieldText">
    <xsl:param name="item"/>
    <xsl:param name="fieldList"/>

    <xsl:variable name="fieldName">
      <xsl:value-of select="ps:getFirstElement($fieldList, ',')"/>
    </xsl:variable>
    <xsl:variable name="remainingFields">
      <xsl:value-of select="ps:removeFirstElement($fieldList, ',')"/>
    </xsl:variable>

    <xsl:choose>
      <!-- actually print out field, if it exists and has content -->
      <xsl:when test="count($item/data[@alias=$fieldName]) = 1 and string($item/data[@alias=$fieldName]) != ''">
        <xsl:value-of select="string($item/data[@alias=$fieldName])"/>
      </xsl:when>

      <xsl:when test="$remainingFields != ''">
        <!-- if this element does not exist, go on to the next one -->
        <xsl:call-template name="displayFieldText">
          <xsl:with-param name="item" select="$item"/>
          <xsl:with-param name="fieldList" select="$remainingFields"/>
        </xsl:call-template>
      </xsl:when>

    </xsl:choose>
  </xsl:template>


  <xsl:template name="booleanAndMatchedNodes">
    <xsl:param name="yetPossibleNodes"/>
    <xsl:param name="searchTermList"/>

    <xsl:variable name="searchTerm">
      <xsl:value-of select="ps:getFirstElement($searchTermList, ' ')"/>
    </xsl:variable>
    <xsl:variable name="remainingSearchTermList">
      <xsl:value-of select="ps:removeFirstElement($searchTermList, ' ')"/>
    </xsl:variable>

    <xsl:variable name="evenYetPossibleNodes" select="$yetPossibleNodes[attribute::*[(contains($searchFields,name())
                                              and contains(ps:uppercase(umbraco.library:StripHtml(string(.))), $searchTerm)) ]]
                                              | 
                                              $yetPossibleNodes[data[(contains($searchFields, concat(',',@alias,','))
                                              and contains(ps:uppercase(umbraco.library:StripHtml(string(.))), $searchTerm)) ]]" />
    <xsl:choose>
      <xsl:when test="string-length($remainingSearchTermList) &gt; 1">
        <!-- continue to search the rest of the terms -->
        <xsl:call-template name="booleanAndMatchedNodes">
          <xsl:with-param name="yetPossibleNodes" select="$evenYetPossibleNodes"/>
          <xsl:with-param name="searchTermList" select="$remainingSearchTermList"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <!-- finished searching: return a list of the attribute @id's of the currently possible nodes as the final set of matched nodes -->
        <xsl:variable name="nodeIDList">
          <xsl:text>;</xsl:text>
          <xsl:for-each select="$evenYetPossibleNodes">
            <!-- @id for this node -->
            <xsl:value-of select="@id"/>
            <xsl:text>;</xsl:text>
          </xsl:for-each>
        </xsl:variable>

        <!-- return the actual list of id's -->
        <xsl:value-of select="$nodeIDList"/>
      </xsl:otherwise>
    </xsl:choose>

  </xsl:template>

  <msxml:script implements-prefix="ps" language="C#">
    <msxml:assembly name="System.Web"/>
    <msxml:using namespace="System.Web"/>
    <![CDATA[
    public double power(double x, double y)
    {
        return Math.Pow(x, y);
    }
    public string uppercase(string s)
    {
        return s.ToUpper();
    }

    public string escapeSearchTerms(string data)
    {
        return data.Replace(Convert.ToString((char)38), "&amp;");
    }

    public string unescapeSearchTerms(string data)
    {
        return data.Replace("&amp;", Convert.ToString((char)38));
    }

    public static double hitCount(string data, string find)
    {
        if (data == null || data == "" || find == null || find == "")
            return 0;

        string after = data.ToLower().Replace(find.ToLower(), "");
        return (data.Length - after.Length) / find.Length;
    }

    public int indexOfMany(string search, string[] find){
      int foundIndex = search.Length;
      foreach(string toFind in find)
          foundIndex = Math.Min(foundIndex, search.ToUpper().IndexOf(toFind.ToUpper()));
      return foundIndex;
    }

    public string contextOfFind(string data, string find, int wordsBefore, int wordsAfter, int maxChars)
    {
        // NOTE: This only makes sense if the searchFields and previewFields are identical.
        // Otherwise, you can find a match but not see its context.
        
        try {
          if (data.Length==0) 
            return "";
            
          string findList = getFirstElement(find, " ");
          find = removeFirstElement(find, " ");
          while (find != ""){
            findList += "|" + getFirstElement(find, " ").ToUpper();
            find = removeFirstElement(find, " ");
          }
          string[] findPhrases = findList.Split('|');

          string remaining = data;
          string output = "";
          int loop = 0;
          string[] after = new string[0];
          
          while (output.Length < maxChars && remaining != "")
          {
            int findIndex = indexOfMany(remaining, findPhrases);
            if (findIndex == -1)
              break;
            findIndex = remaining.IndexOf(" ", findIndex);
            
            if (findIndex == -1) {
              output += remaining;
              break;
            }

            string[] before = remaining.Substring(0, findIndex).Split(' ');
            if (before.Length > wordsBefore)
                output += " ... ";
                
            output += String.Join(" ", before, Math.Max(0, before.Length - wordsBefore), Math.Min(before.Length, wordsBefore));
            remaining = remaining.Substring(findIndex);
            after = remaining.Split(' ');
            string afterText = String.Join(" ", after, 0, Math.Min(after.Length, wordsAfter));
            int nextFindIndex = indexOfMany(afterText, findPhrases);
            if (nextFindIndex > -1)
               nextFindIndex = afterText.IndexOf(" ", nextFindIndex);

            while (nextFindIndex > -1)
            {
                output += afterText.Substring(0, nextFindIndex);
                remaining = remaining.Substring(nextFindIndex);
                after = remaining.Split(' ');            
                afterText = String.Join(" ", after, 0, Math.Min(after.Length, wordsAfter));
                nextFindIndex = indexOfMany(afterText, findPhrases);
                if (nextFindIndex > -1)
                  nextFindIndex = afterText.IndexOf(" ", nextFindIndex);
            }

            output += afterText;
            remaining = remaining.Substring(afterText.Length);
            
          }

          maxChars = (after.Length > wordsAfter) ? maxChars - 3 : maxChars;
          output = output.Trim();

          while (output.Length > maxChars)
            output = output.Substring(0, output.LastIndexOf(" "));

          if (after.Length > wordsAfter)
             output += " ...";

          return output;
        }

        catch {
          return "";
        }
        
    }

    public string surround(string data, string find, string before, string after)
    {
        // searches for find within data, then surrounds it with before and after tags
        // note: replace with the actual text found, to preserve the case
        
        string nextWord = getFirstElement(find, " ");
        string remainingWords = find;
        while (nextWord != "")
        {
            int index = data.ToLower().IndexOf(nextWord.ToLower());
            while (index > -1)
            {
                string replacement = before + data.Substring(index, nextWord.Length) + after;
                data = data.Substring(0, index) + replacement + data.Substring(index + nextWord.Length);
                index = data.ToLower().IndexOf(nextWord.ToLower(), index + replacement.Length );
            }
            remainingWords = removeFirstElement(remainingWords, " ");
            nextWord = getFirstElement(remainingWords, " ");
        }
        return data;
    }

    public long getTime()
    {
        // get current time
        return DateTime.Now.Ticks;
    }

    public double getTimeSpan(long startTime, long stopTime)
    {
        // return time span in milliseconds
        return TimeSpan.FromTicks(stopTime - startTime).TotalMilliseconds;
    }

    public string getFirstElement(string delimitedList, string delimiter)
    {
        // strip all leading delimiters
        while (delimitedList.IndexOf(delimiter) == 0)
            delimitedList = delimitedList.Remove(0, delimiter.Length).Trim();

        if (delimitedList.Length == 0)
            return "";

        // searching on a phrase
        if (delimiter == " " && delimitedList.Substring(0, 1) == "'" && delimitedList.IndexOf("'", 1) > -1)
            return delimitedList.Substring(1, delimitedList.IndexOf("'", 1) - 1);

        if (delimiter == " " && delimitedList.Substring(0, 1) == "\"" && delimitedList.IndexOf("\"", 1) > -1)
            return delimitedList.Substring(1, delimitedList.IndexOf("\"", 1) - 1);

        // only one element
        if (delimitedList.IndexOf(delimiter) == -1)
            return delimitedList.Trim();

        // return first element
        return delimitedList.Split(delimiter.ToCharArray()[0])[0].Trim();
    }

    public string removeFirstElement(string delimitedList, string delimiter)
    {
        string firstElement = getFirstElement(delimitedList, delimiter);

        // handle phrase delimiters
        if (delimiter == " " && delimitedList.Substring(0, 1) == "'" && delimitedList.IndexOf("'", 1) > -1)
            return delimitedList.Remove(0, firstElement.Length + 2).Trim();

        if (delimiter == " " && delimitedList.Substring(0, 1) == "\"" && delimitedList.IndexOf("\"", 1) > -1)
            return delimitedList.Remove(0, firstElement.Length + 2).Trim();

        while (delimitedList.IndexOf(delimiter) == 0)
            delimitedList = delimitedList.Remove(0, delimiter.Length).Trim();

        return delimitedList.Remove(0, firstElement.Length).Trim();
    }

    public string getParameter(string value, string defaultValue)
    {
        if (value == "")
            return defaultValue;
        else
            return value.Replace(" ", "");
    }

    public string getListParameter(string value, string defaultValue)
    {
        // remove all spaces
        value = value.Replace(" ", "");
        defaultValue = defaultValue.Replace(" ", "");

        if (value == "")
            return "," + defaultValue + ",";
        else
            return "," + value + ",";
    }
    public string GetFormattedDate(DateTime dt)
    {
        string str = dt.ToString("dd").TrimStart('0');
        if (dt.Day == 1 || dt.Day == 21 || dt.Day == 31)
            str = string.Concat(str, "st ");
        else if (dt.Day == 2 || dt.Day == 22)
            str = string.Concat(str, "nd ");
        else if (dt.Day == 3 || dt.Day == 23)
            str = string.Concat(str, "rd ");
        else
            str = string.Concat(str, "th ");
        str = string.Concat(str, dt.ToString("MMMM yyyy"));
        return str;
    }
    ]]>
  </msxml:script>
</xsl:stylesheet>