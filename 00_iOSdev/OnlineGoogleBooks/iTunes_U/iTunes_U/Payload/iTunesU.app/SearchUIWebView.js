
var uiWebview_SearchResultCount = 0;
var uiWebview_TopScroll = 0;

/*!
 @method     uiWebview_HighlightAllOccurencesOfStringForElement
 @abstract   // helper function, recursively searches in elements and their child nodes
 @discussion // helper function, recursively searches in elements and their child nodes
 
 element    - HTML elements
 keyword    - string to search
 */

function uiWebview_HighlightAllOccurencesOfStringForElement (element, keyword)
{
	if (element)
	{
		if (element.nodeType == 3)			// <--- Text node
		{
			while (true)
			{
				// Search for keyword in text node.
				var value = element.nodeValue;
				var idx = value.toLowerCase ().indexOf (keyword);
				
				// Not found, abort.
				if (idx < 0)
					break;
				
				// We create a SPAN element for every parts of matched keywords
				var span = document.createElement ("span");
				var text = document.createTextNode (value.substr (idx, keyword.length));
				span.appendChild (text);
				
				span.setAttribute ("class", "uiWebviewHighlight");
				// Highlight color.
				span.style.backgroundColor = "#FFFF99";
				span.style.color = "black";
				
				// Update the counter.
				uiWebview_SearchResultCount++;
				
				text = document.createTextNode (value.substr (idx + keyword.length));
				element.deleteData (idx, value.length - idx);
				var next = element.nextSibling;
				element.parentNode.insertBefore (span, next);
				element.parentNode.insertBefore (text, next);
				element = text;
				
				if (uiWebview_SearchResultCount == 1)
				{
					uiWebview_TopScroll = element.parentNode.offsetTop;
//					alert("uiWebview_TopScroll = " + uiWebview_TopScroll);
				}
			}
        }
		else if (element.nodeType == 1)		// <--- Element node
		{
			if (element.style.display != "none" && element.nodeName.toLowerCase () != 'select')
			{
				for (var i = element.childNodes.length - 1; i >= 0; i--)
					uiWebview_HighlightAllOccurencesOfStringForElement (element.childNodes[i], keyword);
			}
		}
	}
}

// the main entry point to start the search

function uiWebview_HighlightAllOccurencesOfString (keyword)
{
	uiWebview_TopScroll = 0;
	uiWebview_RemoveAllHighlights();
	uiWebview_HighlightAllOccurencesOfStringForElement (document.body, keyword.toLowerCase ());
	if (uiWebview_TopScroll != 0)
		window.scrollTo (0, uiWebview_TopScroll);
}

// Helper function, recursively removes the highlights in elements and their childs

function uiWebview_RemoveAllHighlightsForElement (element)
{
	if (element)
	{
		if (element.nodeType == 1)
		{
			if (element.getAttribute ("class") == "uiWebviewHighlight")
			{
				var text = element.removeChild (element.firstChild);
				element.parentNode.insertBefore (text, element);
				element.parentNode.removeChild (element);
				return true;
			}
			else
			{
				var normalize = false;
				for (var i = element.childNodes.length - 1; i >= 0; i--)
				{
					if (uiWebview_RemoveAllHighlightsForElement (element.childNodes[i]))
						normalize = true;
				}
				
				if (normalize)
					element.normalize ();
			}
		}
	}
	
	return false;
}

// The main entry point to remove the highlights

function uiWebview_RemoveAllHighlights ()
{
	uiWebview_SearchResultCount = 0;
	uiWebview_RemoveAllHighlightsForElement (document.body);
}
