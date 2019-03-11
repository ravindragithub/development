// **************************************************************************
// Copyright 2007 - 2008 Tavs Dokkedahl
// Contact: http://www.jslab.dk/contact.php
//
// This file is part of the JSLab DOM Correction (JDC) Program.
//
// JDC is free software; you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation; either version 3 of the License, or
// any later version.
//
// JDC is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program. If not, see <http://www.gnu.org/licenses/>.
// ***************************************************************************

/*********************************************
*
*   JavaScript Regex Generator
*
**********************************************/

// Namespace
JSL = {};

var freeTxtIdList;
var freeTxtIdCount;
var FieldValueList;
var followedByValueList;
var freeTextValueList;
var countRegexTxt = 0;
var countFreeTxt = 0;
var GroupNumber = 0;
var currentGroupNum;
var countRemovedGroup = 0;
/*********************************************a
*
*   JSL.Rgx
*
**********************************************/

JSL.Rgx =
  function(RecordId) {
	  
	if(typeof RecordId !== "undefined")
	{
		// Container
    var div = document.createElement('div');
    
	
	 ortoo_e2a.RegexGeneratorController.getRecentRegex(RecordId,function(result, event){
			console.log(result);
	var QuantifierIdList = new Array();
	var countId = 0;
	
    // Setup first group
	if(result.isSuccess)
   	{
	$.each(result.GroupList,function(){
   			div.className = 'regex';
		    // Textnode displaying regex
		    div.regex = null;
		    // Human readable text
		    div.regexText = null;
			
		});
		div.groups = [];
		    div.tabs = [];
	$.each(result.GroupList,function(){
	
	// Methods
    div.update = JSL.Rgx.update;
    div.updateText = JSL.Rgx.updateText;
    div.addGroup = JSL.Rgx.addGroup;
    div.removeGroup = JSL.Rgx.removeGroup;
	var storedIds = new Array();
    div.addGroup(this,storedIds);
	/*&if(storedIds!=null)
	{
		alert(storedIds[0]);
		var quantifierEle = document.getElementById(storedIds[0]);
		quantifierEle.num.focus();
	}*/
	
	if(storedIds.length > 0) {
        //alert('Length:' +  storedIds[0]);
		/*var quantifierEle = document.getElementById(storedIds[0]);
		quantifierEle.checked = true;
		storedIds[0] = null;*/
		for(var i=0;i<storedIds.length;i++)
		{
			QuantifierIdList[countId] = storedIds[i];
			countId = countId + 1;
		}
		
	}
		
			if(typeof this.ortoo_e2a__Match_string__c !== "undefined")
			{
				
				
				FieldValueList.push(this.ortoo_e2a__Match_string__c);
			}
			
			if(typeof this.ortoo_e2a__Followed_by__c !== "undefined" && this.ortoo_e2a__Group_Number__c > 1)
			{
				
				
				followedByValueList.push(this.ortoo_e2a__Followed_by__c);
			}
			
			if(typeof this.ortoo_e2a__Free_text__c !== "undefined")
			{
				
				
				freeTextValueList.push(this.ortoo_e2a__Free_text__c);
			}
		
  // Mark first tab as selected   
			if(this.ortoo_e2a__Group_Number__c == 1)
			{
			    div.tabs[0].className += ' selected';
			    div.groups[0].style.display = 'block';
			
			    // Add div for global modifers
			    div.global = document.createElement('div');
			    div.global.style.border = '1px solid #000';
			    div.global.style.marginTop = '4px';
			    div.global.style.padding = '0px';
			    div.global.onclick =
		      	function(e) {
		        	if (e.target.nodeName.toLowerCase() == 'input')
		          	div.update();
		      	};
		      	
		      	//Global Modifiers
			    var strong = document.createElement('strong');
			    strong.style.display = 'block';
				strong.style.padding = '4px';
				strong.setAttribute('title','Global modifiers allow modification of match such as case senstivity and how newline characters are treated. Useful for multi-line matches.');
			    strong.appendChild(document.createTextNode('Global modifiers [?]'));
			    div.global.appendChild(strong);
			    // Case sensitive
			    div.global.i = document.createElement('input');
			    div.global.i.type = 'checkbox';
			    div.global.i.id = 'case';
			    if(result.RecentItem.ortoo_e2a__Case_insensitive__c)
			    {
			    	div.global.i.checked = true;
			    }
			    div.global.appendChild(div.global.i);
			    var label = document.createElement('label');
			    label.htmlFor = div.global.i.id;
			    label.appendChild(document.createTextNode('Case-insensitive'));
			    div.global.appendChild(label);
			    div.global.appendChild(document.createElement('br'));
			    // Multiline
			    div.global.m = document.createElement('input');
			    div.global.m.type = 'checkbox';
			    div.global.m.id = 'multi';
			    if(result.RecentItem.ortoo_e2a__Match_across_newlines__c)
			    {
			    	div.global.m.checked = true;
			    }
			    div.global.appendChild(div.global.m);
			    var label = document.createElement('label');
			    label.htmlFor = div.global.m.id;
			    label.appendChild(document.createTextNode('Match across newlines (multiline)'));
			    div.global.appendChild(label);
			    div.global.appendChild(document.createElement('br'));
			    // Global
			    div.global.g = document.createElement('input');
			    div.global.g.type = 'checkbox';
			    div.global.g.id = 'global';
			    if(result.RecentItem.ortoo_e2a__Dot_matches_newline__c)
			    {
			    	div.global.g.checked = true;
			    }
			    div.global.appendChild(div.global.g);
			    var label = document.createElement('label');
			    label.htmlFor = div.global.g.id;
			    label.appendChild(document.createTextNode('Dot matches newline characters'));
			    div.global.appendChild(label);
			    div.appendChild(div.global);
	      	
   			}
	});
    // Add div for displaying regex
    var con = document.createElement('div');
    con.className = 'infoNote';
    var strong = document.createElement('strong');
    strong.appendChild(document.createTextNode('Generated regular expression'));
    con.appendChild(strong);
    // div holding text
    div.regex = document.createElement('div');
    div.regex.id = 'TargetRegex';
    div.regex.style.fontFamily = 'Courier New';
    div.regex.style.fontSize = '12px';
    div.regex.style.backgroundColor = '#fff';
    div.regex.style.marginTop = '4px';
    div.regex.style.marginBottom = '4px';
    con.appendChild(div.regex);
    // Text node for human readable text
    var strong = document.createElement('strong');
    strong.appendChild(document.createTextNode('Textual meaning of regular expression'));
    con.appendChild(strong);
    div.regexText = document.createElement('div');
    con.appendChild(div.regexText);
    div.appendChild(con);
	RecentItemRegex();
	
    div.update();
	}
	 var id;
	 for(var i = 0;i<QuantifierIdList.length;i++)
	 {
		 id = QuantifierIdList[i];
		 var elem = document.getElementById(id);
		if (typeof elem.onclick == "function") {
			elem.onclick.apply(elem);
		}
	 }
	   
	    if(FieldValueList.length >0)
	 {
		 fieldElement = document.getElementById('selectlist1');
		 if(FieldValueList[0].localeCompare('Match a string which contains') == 0)
		 {
			 fieldElement.value = '';
			 fieldElement.onchange();
		 }
		 else if(FieldValueList[0].localeCompare('Match a string which starts with') == 0)
		 {
			 fieldElement.value = '^';
			 fieldElement.onchange();
		 }
		 else if(FieldValueList[0].localeCompare('Match a string which ends in') == 0)
		 {
			 fieldElement.value = '$';
			 fieldElement.onchange();
		 }
		  else if(FieldValueList[0].localeCompare('Match a string which starts and ends in') == 0)
		 {
			 fieldElement.value = '^$';
			 fieldElement.onchange();
		 }
		 else if(FieldValueList[0].localeCompare('Match a string that comes after') == 0)
		 {
			 fieldElement.value = '?';
			 fieldElement.onchange();
		 }
		 
	 }
	 
	 if(followedByValueList.length > 0)
	 {
		 var count = 2;
		 for(var i=0;i<followedByValueList.length;i++)
		 {
			 //console.log('selectlist'+count);
			 fieldElement = document.getElementById('selectlist'+count);
			 //console.log(fieldElement);
			 if(followedByValueList[i].localeCompare('followed by') == 0)
			 {
				 fieldElement.value = '';
				 fieldElement.onchange();
			 }
			 else if(followedByValueList[i].localeCompare('or') == 0)
			 {
				 fieldElement.value = '|';
				 fieldElement.onchange();
			 }
			 else if(followedByValueList[i].localeCompare('only if followed by') == 0)
			 {
				 fieldElement.value = '?';
				 fieldElement.onchange();
			 }
			 else if(followedByValueList[i].localeCompare('only if not followed by') == 0)
			 {
				 fieldElement.value = '!';
				 fieldElement.onchange();
			 }
			 else if(followedByValueList[i].localeCompare('ending in') == 0)
			 {
				 fieldElement.value = '$';
				 fieldElement.onchange();
			 }
			 
			 count = count + 1;
			 
		 }
	 }

		$.each(result.GroupList,function(){
		var grpnp = this.ortoo_e2a__Group_Number__c;
		ortoo_e2a.RegexGeneratorController.getRecentRegexFields(this.Id,function(result, event){
			 console.log(result);
			 
			 if(result.isSuccess)
   			{ 
				var fieldElement = document.getElementById('input'+grpnp+'_'+'1');
				var flag=false;
				for(var count = 0;count<result.GroupFieldList.length;count++)
				{
					var groupField = result.GroupFieldList[count];
					 //console.log(groupField);
					//div.addField(n,groupField);
					if(flag==true)
					{
					 	fieldElement.onclick();
					}
				   var regexText = document.getElementById('RegexText'+groupField.ortoo_e2a__Group_Number__c+'_'+(count+1));
				   regexText.value = groupField.Name;
				   flag = true;
				}
				
				
			}

		  }
		 );
		});
	 $.each(result.GroupList,function(){1
		ortoo_e2a.RegexGeneratorController.getRecentRegexFields(this.Id,function(result, event){
			 console.log(result);
			 
			 if(result.isSuccess)
   			{ 
				for(var count = 0;count<result.GroupFieldList.length;count++)
				{
					var groupField = result.GroupFieldList[count];
					fieldElement = document.getElementById('FreeText'+groupField.ortoo_e2a__Group_Number__c+'_'+(count+1));
					
					 if(groupField.ortoo_e2a__Free_text__c.localeCompare('Free text') == 0)
					 {
						 var freeTxtList = document.getElementsByClassName('regex');
						//console.log(document.getElementsByClassName('regex'));
						//console.log(document.getElementById('content').innerHTML);
						//console.log('Length: '+freeTxtList.length);
						for(var i=0;i<freeTxtList.length;i++)
						{
							freeTxtList[i].update();
						}
					 }
					else if(groupField.ortoo_e2a__Free_text__c.localeCompare('any character') == 0)
					 {
						 fieldElement.value = '.';
						 fieldElement.onchange();
					 }
					 else if(groupField.ortoo_e2a__Free_text__c.localeCompare('any letter a-z') == 0)
					 {
						 fieldElement.value = '[a-zA-Z]';
						 fieldElement.onchange();
					 }
					 else if(groupField.ortoo_e2a__Free_text__c.localeCompare('any lowercase letter a-z') == 0)
					 {
						 fieldElement.value = '[a-z]';
						 fieldElement.onchange();
					 }
					  else if(groupField.ortoo_e2a__Free_text__c.localeCompare('any uppercase letter A-Z') == 0)
					 {
						 fieldElement.value = '[A-Z]';
						 fieldElement.onchange();
					 }
					 else if(groupField.ortoo_e2a__Free_text__c.localeCompare('any digit 0-9') == 0)
					 {
						 fieldElement.value = '\\d';
						 fieldElement.onchange();
					 }
					 else if(groupField.ortoo_e2a__Free_text__c.localeCompare('any ASCII word character') == 0)
					 {
						 fieldElement.value = '\\w';
						 fieldElement.onchange();
					 }
					  else if(groupField.ortoo_e2a__Free_text__c.localeCompare('any whitespace') == 0)
					 {
						 fieldElement.value = '\\s';
						 fieldElement.onchange();
					 }
					  else if(groupField.ortoo_e2a__Free_text__c.localeCompare('any word boundary') == 0)
					 {
						 fieldElement.value = '\\b';
						 fieldElement.onchange();
					 }
							
				}
				
				
			}
		});

	});
	
	
	 });
	
	
    return div;
	}
	else
	{
		// Container
	
    var div = document.createElement('div');
    div.className = 'regex';
    // Textnode displaying regex
    div.regex = null;
    // Human readable text
    div.regexText = null;
    div.groups = [];
    div.tabs = [];
    // Methods
    div.update = JSL.Rgx.update;
    div.updateText = JSL.Rgx.updateText;
    div.addGroup = JSL.Rgx.addGroup;
    div.removeGroup = JSL.Rgx.removeGroup;
    // Setup first group
    div.addGroup();
    // Mark first tab as selected    
    div.tabs[0].className += ' selected';
    div.groups[0].style.display = 'block';
    // Add div for global modifers
    div.global = document.createElement('div');
    div.global.style.border = '1px solid #000';
    div.global.style.marginTop = '4px';
    div.global.style.padding = '0px';
    div.global.onclick =
      function(e) {
        if (e.target.nodeName.toLowerCase() == 'input')
          div.update();
      };
    var strong = document.createElement('strong');
    strong.style.display = 'block';
	strong.style.padding = '4px';
	strong.setAttribute('title','Global modifiers allow modification of match such as case senstivity and how newline characters are treated. Useful for multi-line matches.');
    strong.appendChild(document.createTextNode('Global modifiers [?]'));
    div.global.appendChild(strong);
    // Case sensitive
    div.global.i = document.createElement('input');
    div.global.i.type = 'checkbox';
    div.global.i.id = 'case';
    div.global.appendChild(div.global.i);
    var label = document.createElement('label');
    label.htmlFor = div.global.i.id;
    label.appendChild(document.createTextNode('Case-insensitive'));
    div.global.appendChild(label);
    div.global.appendChild(document.createElement('br'));
    // Multiline
    div.global.m = document.createElement('input');
    div.global.m.type = 'checkbox';
    div.global.m.id = 'multi';
    div.global.appendChild(div.global.m);
    var label = document.createElement('label');
    label.htmlFor = div.global.m.id;
    label.appendChild(document.createTextNode('Match across newlines (multiline)'));
    div.global.appendChild(label);
    div.global.appendChild(document.createElement('br'));
    // Global
    div.global.g = document.createElement('input');
    div.global.g.type = 'checkbox';
    div.global.g.id = 'global';
    div.global.appendChild(div.global.g);
    var label = document.createElement('label');
    label.htmlFor = div.global.g.id;
    label.appendChild(document.createTextNode('Dot matches newline characters'));
    div.global.appendChild(label);
    div.appendChild(div.global);
    // Add div for displaying regex
    var con = document.createElement('div');
    con.className = 'infoNote';
    var strong = document.createElement('strong');
    strong.appendChild(document.createTextNode('Generated regular expression'));
    con.appendChild(strong);
    // div holding text
    div.regex = document.createElement('div');
    div.regex.id = 'TargetRegex';
    div.regex.style.fontFamily = 'Courier New';
    div.regex.style.fontSize = '12px';
    div.regex.style.backgroundColor = '#fff';
    div.regex.style.marginTop = '4px';
    div.regex.style.marginBottom = '4px';
    con.appendChild(div.regex);
    // Text node for human readable text
    var strong = document.createElement('strong');
    strong.appendChild(document.createTextNode('Textual meaning of regular expression'));
    con.appendChild(strong);
    div.regexText = document.createElement('div');
    con.appendChild(div.regexText);
    div.appendChild(con);
	RecentItemRegex();
    div.update();
	
    return div;
	}
  };


JSL.Rgx.colors = ['#00f','#0a0','#a00','#0aa','#a0a','#cc0','#aaa'];

// Update regex
JSL.Rgx.update =
  function() {
    // Assume regex is not ending on every update
    // This prop. is set by JSL.Rgx.Group.Update
    this.end = false;
    var s = '';
    // For each group
	var a = this.groups;
    var l = a.length; 
    
    for(var i=0; i<l; i++)
    {
      s += a[i].getValue(i);
      
      
    }
	//console.log(this);
	//console.log(this.regex);
    if (this.end)
      s += this.end;
    //s = '/' + s+ '/';
    if (this.global.i.checked)
      s = '(?i)' + s;
    if (this.global.m.checked)
      s = '(?m)' + s;
    if (this.global.g.checked)
      s = '(?s)'+ s;
    this.regex.innerHTML = s;
    this.updateText();
  };

JSL.Rgx.updateText =
  function() {
    var s = '';
    // For each group
    var a = this.groups;
    var l = a.length;
    for(var i=0; i<l; i++)
      s += a[i].getText(i);
    this.regexText.innerHTML = s;
  };

// Add group tab
JSL.Rgx.addGroup =
   function(obj,storedIds) {
	if(typeof obj !== "undefined" && typeof storedIds !== "undefined") 
	{ 
		
    var n = this.groups.length;
    if (n > 6) {
      alert('Only ' + n + ' groups in beta version');
      return;
    }
    // If no groups/tabs yet add container
    if (!n) {
      // Container for tabs
      this.tabCon = document.createElement('div');
      // Event listener for selecting tab
      this.tabCon.onclick = JSL.Rgx.selectTab;
      this.tabCon.className = 'tabCon';
      // Add tab for adding groups
      var div = JSL.Rgx.GroupTab('Add group', true);
      div.addgroup = true;
      div.style.borderTopWidth = '3px';
      this.tabCon.appendChild(div);
      // Add clearing div for floats
      var clear = document.createElement('div');
      clear.className = 'clear';
      this.tabCon.appendChild(clear);
      this.appendChild(this.tabCon);
    }
    // Add tab before 'add group' tab
    // Only enable close if not first tab
    if (n)
      var tab = JSL.Rgx.GroupTab('Group ' + (n + 1));
    else
      var tab = JSL.Rgx.GroupTab('Group ' + (n + 1), true);
    this.tabs.push(tab);
    //tab.style.backgroundColor = JSL.Rgx.colors[n % 7];
    tab.style.borderTopColor = JSL.Rgx.colors[n % JSL.Rgx.colors.length];
    tab.style.borderTopWidth = '3px';
    this.tabCon.insertBefore(tab, this.tabCon.lastChild.previousSibling);
    // Create new group
	
    tab.group = JSL.Rgx.Group(n + 1 , obj,storedIds);
    this.groups.push(tab.group);
    // If first group insert as last child
    if (!n)
      this.appendChild(tab.group);
    // else insert before text displaying regex
    else {
      this.insertBefore(tab.group, this.global);
      // We need to select the first radio button in IE now
      if (document.createEventObject) {
        document.getElementById('qty' + (n + 1) + '_0').checked = true;
      }
    }
	
    // Select group. This can not be done initially as there are no tab element
    // to dispatch the event to.
    if (n) {
      var e = document.createEvent('MouseEvent');
      e.initMouseEvent('click', true, true, window, 1, 0, 0, 0, 0, false, false, false, false, 0, null);
      tab.dispatchEvent(e);
    }
	}
	else
	{
		
		 var n = this.groups.length;
    if (n > 6) {
      alert('Only ' + n + ' groups in beta version');
      return;
    }
    // If no groups/tabs yet add container
    if (!n) {
      // Container for tabs
      this.tabCon = document.createElement('div');
      // Event listener for selecting tab
      this.tabCon.onclick = JSL.Rgx.selectTab;
      this.tabCon.className = 'tabCon';
      // Add tab for adding groups
      var div = JSL.Rgx.GroupTab('Add group', true);
      div.addgroup = true;
      div.style.borderTopWidth = '3px';
      this.tabCon.appendChild(div);
      // Add clearing div for floats
      var clear = document.createElement('div');
      clear.className = 'clear';
      this.tabCon.appendChild(clear);
      this.appendChild(this.tabCon);
    }
    // Add tab before 'add group' tab
    // Only enable close if not first tab
    if (n)
      var tab = JSL.Rgx.GroupTab('Group ' + (n + 1));
    else
      var tab = JSL.Rgx.GroupTab('Group ' + (n + 1), true);
    this.tabs.push(tab);
    //tab.style.backgroundColor = JSL.Rgx.colors[n % 7];
    tab.style.borderTopColor = JSL.Rgx.colors[n % JSL.Rgx.colors.length];
    tab.style.borderTopWidth = '3px';
    this.tabCon.insertBefore(tab, this.tabCon.lastChild.previousSibling);
    // Create new group
    tab.group = JSL.Rgx.Group(n + 1);
    this.groups.push(tab.group);
    // If first group insert as last child
    if (!n)
      this.appendChild(tab.group);
    // else insert before text displaying regex
    else {
      this.insertBefore(tab.group, this.global);
      // We need to select the first radio button in IE now
      if (document.createEventObject) {
        document.getElementById('qty' + (n + 1) + '_0').checked = true;
      }
    }
    // Select group. This can not be done initially as there are no tab element
    // to dispatch the event to.
    if (n) {
      var e = document.createEvent('MouseEvent');
      e.initMouseEvent('click', true, true, window, 1, 0, 0, 0, 0, false, false, false, false, 0, null);
      tab.dispatchEvent(e);
    }
		
	}
  };

// Remove group tab
JSL.Rgx.removeGroup =
  function(tab) {
	 
    var i = 0;
	var flag = 0;
    while(this.tabs[i] != tab)
      i++;
    // Remove group
    this.removeChild(this.groups[i]);
    // Remove tab
    this.tabCon.removeChild(tab);
	var fieldElement,freeElement,selectElement,groupElement;
	var quant,group;
	console.log('this.groups.length:' + this.groups.length);
	console.log('i:' + i);
	    // Reorder groups and tabs
    for(var j=i; j<this.groups.length - 1; j++) { 
		console.log('j:'+j);
		console.log('RegexText'+(j+1));
		//document.getElementById('RegexText'+(j+2))
		groupElement = document.getElementById('group'+(j+2));
		for(var count = 1;count<groupElement.value;count++)
		{
			fieldElement = document.getElementById('RegexText'+(j+2)+'_'+count);
			fieldElement.setAttribute('id','RegexText'+(j+1)+'_'+count);
		}
		for(var count = 1;count<groupElement.value;count++)
		{
			fieldElement = document.getElementById('FreeText'+(j+2)+'_'+count);
			fieldElement.setAttribute('id','FreeText'+(j+1)+'_'+count);
		}
		groupElement.setAttribute('id','group'+(j+1));
		//fieldElement = document.getElementById('RegexText'+(j+2));
		//fieldElement.setAttribute('id','RegexText'+(j+1));
		//freeElement = document.getElementById('FreeText'+(j+2));
		//freeElement.setAttribute('id','FreeText'+(j+1));
		freeElement = document.getElementById('selectlist'+(j+2));
		freeElement.setAttribute('id','selectlist'+(j+1));
		quant = document.getElementById('qty'+(j+2)+'_0');
		quant.setAttribute('id','qty'+(j+1)+'_0');
		quant = document.getElementById('qty'+(j+2)+'_1');
		quant.setAttribute('id','qty'+(j+1)+'_1');
		quant = document.getElementById('qty'+(j+2)+'_2');
		quant.setAttribute('id','qty'+(j+1)+'_2');
		quant = document.getElementById('qty'+(j+2)+'_3');
		quant.setAttribute('id','qty'+(j+1)+'_3');
		quant = document.getElementById('qty'+(j+2)+'_4');
		quant.setAttribute('id','qty'+(j+1)+'_4');
		quant= document.getElementById('f1qty'+(j+2)+'_0')
		quant.setAttribute('id','f1qty'+(j+1)+'_0');
		quant= document.getElementById('f1qty'+(j+2)+'_1')
		quant.setAttribute('id','f1qty'+(j+1)+'_1');
		quant= document.getElementById('f1qty'+(j+2)+'_2')
		quant.setAttribute('id','f1qty'+(j+1)+'_2');
		quant= document.getElementById('f2qty'+(j+2)+'_2')
		quant.setAttribute('id','f2qty'+(j+1)+'_2');
		group = document.getElementById('qty'+(j+2)+'_5');
		group.setAttribute('id','qty'+(j+1)+'_5');
		group = document.getElementById('qty'+(j+2)+'_6');
		group.setAttribute('id','qty'+(j+1)+'_6');
		group = document.getElementById('qty'+(j+2)+'_7');
		group.setAttribute('id','qty'+(j+1)+'_7');
		
      this.groups[j] = this.groups[j + 1];
      this.tabs[j] = this.tabs[j + 1];
      // Re-number tabs
      this.tabs[j].firstChild.nodeValue = 'Group ' + (j + 1); 
      // Re-color tabs
      this.tabs[j].style.borderTopColor = JSL.Rgx.colors[j % JSL.Rgx.colors.length];
	  console.log('test');
	  countRemovedGroup = countRemovedGroup + 1;
	  flag = 1;
    }
	
	if(flag == 0)
	{	
		$('#group'+ GroupNumber).remove();

	}
	else
	{
		$('#group'+ (i+1)).remove();
	}
	
	GroupNumber = GroupNumber -1;
    this.groups.pop();
    this.tabs.pop();
    // If removing selected tab
    if (/selected/.test(tab.className)) {
      // If removing last group select previous group
      if (i == this.tabs.length)
        tab = this.tabs[i - 1];
      // If not last group select next group
      else
        tab = this.tabs[i];
      // Select new tab
      var e = document.createEvent('MouseEvent');
      e.initMouseEvent('click', true, true, window, 1, 0, 0, 0, 0, false, false, false, false, 0, null);
      tab.dispatchEvent(e);
    }
	countRegexTxt = countRegexTxt - 1;
	countFreeTxt = countFreeTxt - 1;
    this.update();
	
  };
// Select a tag by index
JSL.Rgx.selectTabByIndex = 
  function(e,i) {
	   
    var evt = document.createEvent('MouseEvent');
    evt.initMouseEvent('click', true, true, window, 1, 0, 0, 0, 0, false, false, false, false, 0, null);
    e.target.parentNode.parentNode.parentNode.tabs[i].dispatchEvent(evt);
  };

// Select a tab
JSL.Rgx.selectTab =
  function(e) {
	  
	 console.log(e);
	
	 var reg = e.srcElement.innerHTML.match(/\d+/)
	 if(reg)
	 {
	 	console.log( reg[0]); 
		currentGroupNum = reg[0];
	 }
	 
    // If removing group
    if (e.target.nodeName.toLowerCase() == 'span') {
      e.currentTarget.parentNode.removeGroup(e.target.parentNode);
      return;
    }
    // If target is not on a tab just return
    if (e.target.className != 'tab')
      return;
    // If adding group
    if (e.target.addgroup) {
      e.currentTarget.parentNode.addGroup();
      return;
    }
    var a = this.childNodes;
    var l = a.length - 2;
    // For each tab
    for(var i=0; i<l; i++) {
      // Deselect selected tab
      if (a[i].group.style.display == 'block') {
        // Unselect tab
        a[i].className = a[i].className.replace(/\s*selected\s*/,'');
        // Hide group
        a[i].group.style.display = 'none';
        
        break;
      }
    }
    // Select new tab
    e.target.className += ' selected';
    // Show new group
    e.target.group.style.display = 'block';
  };

/*********************************************
*
*   JSL.Rgx.GroupTab
*
**********************************************/

JSL.Rgx.GroupTab =
  function(s,close) {
    var div = document.createElement('div');
    div.appendChild(document.createTextNode(s));
	if (!close) {
        var img = document.createElement('span');
        img.innerHTML = "&nbsp;&nbsp;&nbsp;[X]"
        //img.appendChild(document.createTextNode('(Close)'));
       //var img = document.createElement('img');
       //img.src = '{!JSENCODE($Resource.regex_close_icon)}'; 
      //img.src = '/resource/1431073056000/regex_close_icon';//'{!JSENCODE($Resource.regex_close_icon)}'; //'../gfx/regex_close.gif';
      //img.alt = img.title = 'Close group';
      div.appendChild(img);
    }
    div.className = 'tab';
    return div;
  };
 
/*********************************************
*
*   JSL.Rgx.Group
*
**********************************************/

// n is the group index
JSL.Rgx.Group =
  function(n , obj,storedIds) {
	GroupNumber =GroupNumber+1; 
	console.log('GroupNumber' + GroupNumber);
	if(typeof obj !== "undefined" && typeof storedIds !== "undefined" && typeof n !== "undefined")
	{
		
    // Container
	var div = document.createElement('div');
    // Select
	div.begin = JSL.Rgx.Group.Field.Begin(n);
    // Raw regex
    div.rgx = '';
    // Free input fields
    div.fields = [];
    // Quantifier human readable string
    div.qtyText = '';
    // Quantifier regex string
    div.qty = '';
    // Application of qty
    div.qtyGroup = false;
    // Group fields
    div.qtyGroupFields = false;
    // Capture group
    div.capture = false;
    div.className = 'group';
    // Methods
    div.addField = JSL.Rgx.Group.addField;
    div.removeField = JSL.Rgx.Group.removeField;
    div.getValue = JSL.Rgx.Group.getValue;
    div.getText = JSL.Rgx.Group.getText
    // Add begin field to group
    div.appendChild(div.begin);
    div.appendChild(document.createElement('hr'));

	
    div.addField(n,obj);
    // Add quantifier
    div.appendChild(document.createElement('hr'));
    // Add div for displaying Quantifier caption
    var con1 = document.createElement('div');
    con1.className = 'infoNote1';
    con1.id = 'TargetRegex1';
    con1.style.fontWeight= 'bold';
    var strong1 = document.createElement('strong');
	 strong1.style.display = 'block';
	 strong1.setAttribute('title','Quantifiers specify how many instances of a character, group, or character class must be present in the input for a match to be found.');
    strong1.appendChild(document.createTextNode('Quantifiers [?]'));
    con1.appendChild(strong1);
    // div holding text
    
    div.appendChild(con1);
    // Reset ID counter
    JSL.Rgx.Group.Radio.id = 0;
    // Match exactly
    var radio = JSL.Rgx.Group.Radio(n);
    radio.style.verticalAlign = 'top';
    // 'exact' is default selected
    if(obj != null && obj.ortoo_e2a__Quantifier__c == 1)
	{
    	radio.checked = true;
		storedIds.push(radio.id);
	}
    // Label for 'exact'
    var label = document.createElement('label');
    label.htmlFor = radio.id;
    if (!document.createEventObject)
      label.onclick = JSL.Rgx.Group.RadioForceSelect;
    label.appendChild(document.createTextNode('Exactly '));
   if(obj != null && typeof obj.ortoo_e2a__Quantifier_Val_1__c !== 'undefined' && obj.ortoo_e2a__Quantifier__c==1)
    radio.num = JSL.Rgx.Group.Numeric(obj.ortoo_e2a__Quantifier_Val_1__c, JSL.Rgx.Group.Numeric.exact);
	else
	{
		radio.num = JSL.Rgx.Group.Numeric(1, JSL.Rgx.Group.Numeric.exact);
	}
    radio.num.id = 'f1'+radio.id
    label.appendChild(radio.num);
    label.appendChild(document.createTextNode(' time(s)'));
    div.appendChild(radio);
    div.appendChild(label);
    div.appendChild(document.createElement('br'));
    // Match more than
    var radio = JSL.Rgx.Group.Radio(n);
    radio.style.verticalAlign = 'top';
	if(obj != null && obj.ortoo_e2a__Quantifier__c == 2)
	{
    	radio.checked = true;
		storedIds.push(radio.id);
	}
    // Label for 'exact'
    var label = document.createElement('label');
    label.htmlFor = radio.id;
    if (!document.createEventObject)
      label.onclick = JSL.Rgx.Group.RadioForceSelect;
	if(obj != null && typeof obj.ortoo_e2a__Quantifier_Val_1__c !== 'undefined' && obj.ortoo_e2a__Quantifier__c == 2)
	{
      radio.num = JSL.Rgx.Group.Numeric(obj.ortoo_e2a__Quantifier_Val_1__c, JSL.Rgx.Group.Numeric.moreThan);
	  
	 }
	 else{
    	radio.num = JSL.Rgx.Group.Numeric(1, JSL.Rgx.Group.Numeric.moreThan);
	 }
    radio.num.id = 'f1'+radio.id;

    label.appendChild(radio.num);
    label.appendChild(document.createTextNode(' or more times'));
    div.appendChild(radio);
    div.appendChild(label);
    div.appendChild(document.createElement('br'));
    // Match in between
    var radio = JSL.Rgx.Group.Radio(n);
    radio.style.verticalAlign = 'top';
	 if(obj != null && obj.ortoo_e2a__Quantifier__c == 3)
	 {
    	radio.checked = true;
		storedIds.push(radio.id);
	 }
    // Label for 'between'
    var label = document.createElement('label');
    label.htmlFor = radio.id;
    if (!document.createEventObject)
      label.onclick = JSL.Rgx.Group.RadioForceSelect;
	label.appendChild(document.createTextNode('Between '));
    if(obj != null && obj.ortoo_e2a__Quantifier__c == 3 && typeof obj.ortoo_e2a__Quantifier_Val_1__c !== 'undefined' && obj.ortoo_e2a__Quantifier_Val_2__c != 'undefined')
    {
    	radio.num = JSL.Rgx.Group.Numeric(obj.ortoo_e2a__Quantifier_Val_1__c, JSL.Rgx.Group.Numeric.between);
		label.appendChild(radio.num);
	    label.appendChild(document.createTextNode(' and '));
	    radio.num2 = JSL.Rgx.Group.Numeric(obj.ortoo_e2a__Quantifier_Val_2__c, JSL.Rgx.Group.Numeric.between);
    }
    else
    {
	    radio.num = JSL.Rgx.Group.Numeric(0, JSL.Rgx.Group.Numeric.between);
		label.appendChild(radio.num);
	    label.appendChild(document.createTextNode(' and '));
	    radio.num2 = JSL.Rgx.Group.Numeric(1, JSL.Rgx.Group.Numeric.between);
    }
    radio.num.id = 'f1'+radio.id
    radio.num2.id = 'f2'+radio.id
    label.appendChild(radio.num2);
    label.appendChild(document.createTextNode(' times'));
    div.appendChild(radio);
    div.appendChild(label);
    div.appendChild(document.createElement('br'));
    // Match any number of times greedy
    var radio = JSL.Rgx.Group.Radio(n);
    radio.style.verticalAlign = 'top';
	if(obj != null && obj.ortoo_e2a__Quantifier__c == 4)
	{
    	radio.checked = true;
		storedIds.push(radio.id);
	}
    // Label for 'any number of times'
    var label = document.createElement('label');
    label.htmlFor = radio.id;
    label.appendChild(document.createTextNode('Any number of times (greedy)'));
    radio.greedy = true;
    div.appendChild(radio);
    div.appendChild(label);
    div.appendChild(document.createElement('br'));
    // Match any number of times non-greedy
    var radio = JSL.Rgx.Group.Radio(n);
    radio.style.verticalAlign = 'top';
	if(obj != null && obj.ortoo_e2a__Quantifier__c == 5)
	{
    	radio.checked = true;
		storedIds.push(radio.id);
	}
    // Label for 'any number of times'
    var label = document.createElement('label');
    label.htmlFor = radio.id;
    label.appendChild(document.createTextNode('Any number of times until next group (non-greedy)'));
    div.appendChild(radio);
    div.appendChild(label);
    // Application of quantifier
    div.appendChild(document.createElement('hr'));
    // Add div for displaying Quantifier caption
    var con2 = document.createElement('div');
    con2.className = 'infoNote2';
    con2.id = 'TargetRegex2';
    con2.style.fontWeight= 'bold';
    var strong2 = document.createElement('strong');
	strong2.style.display = 'block';
	strong2.setAttribute('title','Grouping parts of the regular expression together allows to apply a quantifier to the entire group or to restrict alternation to that part of the regular expression.');
    strong2.appendChild(document.createTextNode('Groups [?]'));
    con2.appendChild(strong2);
    // div holding text
    
    div.appendChild(con2);
    var cb = document.createElement('input');
    cb.type = 'checkbox';
    cb.id = 'qty' + n + '_' + JSL.Rgx.Group.Radio.id++;
    cb.style.marginLeft = 0;
    cb.onclick = function(e) {div.qtyGroup = this.checked; div.parentNode.update();};
    var label = document.createElement('label');
    label.htmlFor = cb.id;
	if(obj != null && obj.ortoo_e2a__Apply_quantifier__c)
	{
    	cb.checked = true;
		storedIds.push(cb.id);
	}
    label.appendChild(document.createTextNode('Apply quantifier to entire group'));
    div.appendChild(cb);
    div.appendChild(label);
    div.appendChild(document.createElement('br'));
    // Group fields
    var cb = document.createElement('input');
    cb.type = 'checkbox';
    cb.id = 'qty' + n + '_' + JSL.Rgx.Group.Radio.id++;
	
    cb.style.marginLeft = 0;
    cb.onclick = function(e) {
		
		div.qtyGroupFields = this.checked; div.parentNode.update();};
    var label = document.createElement('label');
    label.htmlFor = cb.id;
	if(obj != null && obj.ortoo_e2a__Group_fields__c)
	{
    	cb.checked = true;
		storedIds.push(cb.id);
	}
    label.appendChild(document.createTextNode('Group fields'));
    div.appendChild(cb);
    div.appendChild(label);
    div.appendChild(document.createElement('br'));
    // Capture group
    var cb = document.createElement('input');
    cb.type = 'checkbox';
    cb.id = 'qty' + n + '_' + JSL.Rgx.Group.Radio.id++;
    cb.style.marginLeft = 0;
    cb.onclick = function(e) {div.capture = this.checked; div.parentNode.update();};
    var label = document.createElement('label');
    label.htmlFor = cb.id;
	if(obj != null && obj.ortoo_e2a__Capture_group__c)
	{
    	cb.checked = true;
		storedIds.push(cb.id);
	}
    label.appendChild(document.createTextNode('Capture group'));
    div.appendChild(cb);
    div.appendChild(label); 
    return div;
   
	}
	else
	{
		// Container
	
    var div = document.createElement('div');
    // Select
	div.begin = JSL.Rgx.Group.Field.Begin(n);
    // Raw regex
    div.rgx = '';
    // Free input fields
    div.fields = [];
    // Quantifier human readable string
    div.qtyText = '';
    // Quantifier regex string
    div.qty = '';
    // Application of qty
    div.qtyGroup = false;
    // Group fields
    div.qtyGroupFields = false;
    // Capture group
    div.capture = false;
    div.className = 'group';
    // Methods
    div.addField = JSL.Rgx.Group.addField;
	div.removeField = JSL.Rgx.Group.removeField;
    div.getValue = JSL.Rgx.Group.getValue;
    div.getText = JSL.Rgx.Group.getText
    // Add begin field to group
    div.appendChild(div.begin);
    div.appendChild(document.createElement('hr'));
    // Add first field to group
     div.addField();
    // Add quantifier
    div.appendChild(document.createElement('hr'));
    // Add div for displaying Quantifier caption
    var con1 = document.createElement('div');
    con1.className = 'infoNote1';
    con1.id = 'TargetRegex1';
    con1.style.fontWeight= 'bold';
    var strong1 = document.createElement('strong');
	 strong1.style.display = 'block';
	 strong1.setAttribute('title','Quantifiers specify how many instances of a character, group, or character class must be present in the input for a match to be found.');
    strong1.appendChild(document.createTextNode('Quantifiers [?]'));
    con1.appendChild(strong1);
    // div holding text
    
    div.appendChild(con1);
    // Reset ID counter
    JSL.Rgx.Group.Radio.id = 0;
    // Match exactly
    var radio = JSL.Rgx.Group.Radio(n);
    radio.style.verticalAlign = 'top';
    // 'exact' is default selected
    radio.checked = true;
    // Label for 'exact'
    var label = document.createElement('label');
    label.htmlFor = radio.id;
    if (!document.createEventObject)
      label.onclick = JSL.Rgx.Group.RadioForceSelect;
    label.appendChild(document.createTextNode('Exactly '));
    radio.num = JSL.Rgx.Group.Numeric(1, JSL.Rgx.Group.Numeric.exact);
	 radio.num.id = 'f1'+radio.id
    label.appendChild(radio.num);
    label.appendChild(document.createTextNode(' time(s)'));
    div.appendChild(radio);
    div.appendChild(label);
    div.appendChild(document.createElement('br'));
    // Match more than
    var radio = JSL.Rgx.Group.Radio(n);
    radio.style.verticalAlign = 'top';
    // Label for 'exact'
    var label = document.createElement('label');
    label.htmlFor = radio.id;
    if (!document.createEventObject)
      label.onclick = JSL.Rgx.Group.RadioForceSelect;
    radio.num = JSL.Rgx.Group.Numeric(1, JSL.Rgx.Group.Numeric.moreThan);
	 radio.num.id = 'f1'+radio.id;
    label.appendChild(radio.num);
    label.appendChild(document.createTextNode(' or more times'));
    div.appendChild(radio);
    div.appendChild(label);
    div.appendChild(document.createElement('br'));
    // Match in between
    var radio = JSL.Rgx.Group.Radio(n);
    radio.style.verticalAlign = 'top';
    // Label for 'between'
    var label = document.createElement('label');
    label.htmlFor = radio.id;
    if (!document.createEventObject)
      label.onclick = JSL.Rgx.Group.RadioForceSelect;
    label.appendChild(document.createTextNode('Between '));
    radio.num = JSL.Rgx.Group.Numeric(0, JSL.Rgx.Group.Numeric.between);
    label.appendChild(radio.num);
    label.appendChild(document.createTextNode(' and '));
    radio.num2 = JSL.Rgx.Group.Numeric(1, JSL.Rgx.Group.Numeric.between);
	radio.num.id = 'f1'+radio.id
    radio.num2.id = 'f2'+radio.id
    label.appendChild(radio.num2);
    label.appendChild(document.createTextNode(' times'));
    div.appendChild(radio);
    div.appendChild(label);
    div.appendChild(document.createElement('br'));
    // Match any number of times greedy
    var radio = JSL.Rgx.Group.Radio(n);
    radio.style.verticalAlign = 'top';
    // Label for 'any number of times'
    var label = document.createElement('label');
    label.htmlFor = radio.id;
    label.appendChild(document.createTextNode('Any number of times (greedy)'));
    radio.greedy = true;
    div.appendChild(radio);
    div.appendChild(label);
    div.appendChild(document.createElement('br'));
    // Match any number of times non-greedy
    var radio = JSL.Rgx.Group.Radio(n);
    radio.style.verticalAlign = 'top';
    // Label for 'any number of times'
    var label = document.createElement('label');
    label.htmlFor = radio.id;
    label.appendChild(document.createTextNode('Any number of times until next group (non-greedy)'));
    div.appendChild(radio);
    div.appendChild(label);
    // Application of quantifier
    div.appendChild(document.createElement('hr'));
    // Add div for displaying Quantifier caption
    var con2 = document.createElement('div');
    con2.className = 'infoNote2';
    con2.id = 'TargetRegex2';
    con2.style.fontWeight= 'bold';
    var strong2 = document.createElement('strong');
	strong2.style.display = 'block';
	strong2.setAttribute('title','Grouping parts of the regular expression together allows to apply a quantifier to the entire group or to restrict alternation to that part of the regular expression.');
    strong2.appendChild(document.createTextNode('Groups [?]'));
    con2.appendChild(strong2);
    // div holding text
    
    div.appendChild(con2);
    var cb = document.createElement('input');
    cb.type = 'checkbox';
    cb.id = 'qty' + n + '_' + JSL.Rgx.Group.Radio.id++;
    cb.style.marginLeft = 0;
    cb.onclick = function(e) {div.qtyGroup = this.checked; div.parentNode.update();};
    var label = document.createElement('label');
    label.htmlFor = cb.id;
    label.appendChild(document.createTextNode('Apply quantifier to entire group'));
    div.appendChild(cb);
    div.appendChild(label);
    div.appendChild(document.createElement('br'));
    // Group fields
    var cb = document.createElement('input');
    cb.type = 'checkbox';
    cb.id = 'qty' + n + '_' + JSL.Rgx.Group.Radio.id++;
    cb.style.marginLeft = 0;
    cb.onclick = function(e) {div.qtyGroupFields = this.checked; div.parentNode.update();};
    var label = document.createElement('label');
    label.htmlFor = cb.id;
    label.appendChild(document.createTextNode('Group fields'));
    div.appendChild(cb);
    div.appendChild(label);
    div.appendChild(document.createElement('br'));
    // Capture group
    var cb = document.createElement('input');
    cb.type = 'checkbox';
    cb.id = 'qty' + n + '_' + JSL.Rgx.Group.Radio.id++;
    cb.style.marginLeft = 0;
    cb.onclick = function(e) {div.capture = this.checked; div.parentNode.update();};
    var label = document.createElement('label');
    label.htmlFor = cb.id;
    label.appendChild(document.createTextNode('Capture group'));
    div.appendChild(cb);
    div.appendChild(label);

    return div;
	}
  };


// Utility function for creating radio buttons
JSL.Rgx.Group.Radio =
  function(n) {
    var input;
    // If IE
    if (document.createEventObject)
      input = document.createElement('<input name="qty' + n + '" >');
    else {
      input = document.createElement('input');
      input.name = 'qty' + n;
    }
    input.type = 'radio';
    input.id = 'qty' + n + '_' + JSL.Rgx.Group.Radio.id++;
    input.onclick = JSL.Rgx.Group.Radio.onclick;
    input.style.marginLeft = 0;
    input.style.marginRight = '4px';
    return input;
  };

// Update regex on click
JSL.Rgx.Group.Radio.onclick =
  function(e) {
    // Update is implicitely called by onkeyup handler for numeric inputs
    // If 'any number of times' is selected then this.num does not exist
	
    if (this.num)
	{
      
	   this.num.onkeyup.call(this.num);
	   
	}
    else {
      if (this.greedy) {
        this.parentNode.qty = '*';
        this.parentNode.qtyText = 'any number of times';
      }
      else {
        this.parentNode.qty = '*?';
        this.parentNode.qtyText = 'any number of times until next group';
      }
	 
      this.parentNode.parentNode.update();
	  
    }
	
  };

// Make sure radio button is selected when text input
// inside label is selected
JSL.Rgx.Group.RadioForceSelect =
  function(e) {
    if (e.target.nodeName.toLowerCase() == 'input') {
      e.preventDefault();
      document.getElementById(this.htmlFor).checked = true;
      e.target.focus();
    }
  };

// Utility function for placing inputs in label
JSL.Rgx.Group.Numeric =
  function(n, f) {
    var input = document.createElement('input');
    input.value = n;
    input.style.textAlign = 'right';
    input.style.width = '24px';
    input.onkeyup = f;
    // Onfocus select radio button
    if (!document.createEventObject) {
      input.onfocus =
        function(e) {
          e.target.parentNode.previousSibling.checked = true;
          e.target.onkeyup.call(e.target);
        };
    }
    else {
      input.onfocus =
        function(e) {
          e.target.parentNode.previousSibling.checked = true;
          //JSL.Rgx.Group.Numeric.exact.call(e.target);
          e.target.onkeyup.call(e.target);
        };
    }
    return input;
  };

// Update exact
JSL.Rgx.Group.Numeric.exact =
  function(e) {
    // Strip non digits
    this.value = this.value.replace(/\D*/g,'');
    // Convert to number
    var n = this.value * 1;
    var qty;
    var qtyText;
    if (n < 2) {
      qty = '';
      qtyText = '';
    }
    else {
      qty = '{' + n + '}';
      qtyText = 'exactly ' + n + ' times';
    }
    this.parentNode.parentNode.qty = qty;
    this.parentNode.parentNode.qtyText = qtyText;
    this.parentNode.parentNode.parentNode.update();
  };

// Update more than
JSL.Rgx.Group.Numeric.moreThan =
  function(e) {
    // Strip non digits
    this.value = this.value.replace(/\D*/g,'');
    // Convert to number
    var n = this.value * 1;
    var qty;
    var qtyText;
    if (n < 1) {
      qty = '*';
      qtyText = 'any number of times';
    }
    else if (n == 1) {
      qty = '+';
      qtyText = '1 or more times';
    }
    else {
      qty = '{' + n + ',}';
      qtyText = 'more than ' + n + ' times';
    }
    this.parentNode.parentNode.qty = qty;
    this.parentNode.parentNode.qtyText = qtyText;
    this.parentNode.parentNode.parentNode.update();
  };


// Update in between
JSL.Rgx.Group.Numeric.between =
  function(e) {
    // Get both inputs
    var other = this.parentNode.previousSibling.num == this ? this.parentNode.previousSibling.num2 : this.parentNode.previousSibling.num;
    // Strip non digits
    this.value = this.value.replace(/\D*/g,'');
    other.value = other.value.replace(/\D*/g,'');
    // Convert to number
    var n = this.value * 1;
    var m = other.value * 1;
    // Let m be the smaller value
    if (m > n) {
      var tmp = m;
      m = n;
      n = tmp;
    }
    var qty;
    var qtyText;
    if (m < 1 && n < 1) {
      qty = '';
      qtyText = '';
    }
    else if (m < 1 && n == 1) {
      qty = '?';
      qtyText = '0 or 1 times';
    }
    else if (m == 1 && n == 1) {
      qty = '';
      qtyText = '';
    }
    else if (m == n) {
      qty = '{' + m + '}';
      qtyText = 'exactly ' + m + ' times';
    }
    else {
      qty = '{' + m + ',' + n + '}';
      qtyText = 'between ' + m + ' and ' + n + ' times';
    }
    this.parentNode.parentNode.qty = qty;
    this.parentNode.parentNode.qtyText = qtyText;
    this.parentNode.parentNode.parentNode.update();
  };


// Add field to group
JSL.Rgx.Group.addField = 
  function(groupnumber, obj) {
	 if(typeof obj !== "undefined" && typeof groupnumber !== "undefined")
	 {
		
		  var f = JSL.Rgx.Group.Field(this.fields.length,groupnumber, obj);
		if (!this.fields.length)
		  this.appendChild(f);
		else
		  this.insertAfter(f, this.fields[this.fields.length - 1]);
		this.fields.push(f); 
				
								 
	 }
	 else if(typeof groupnumber !== "undefined")
	 {
		 console.log('addField groupnumber:'+groupnumber);
		 var f = JSL.Rgx.Group.Field(this.fields.length,groupnumber);
		if (!this.fields.length)
		  this.appendChild(f);
		else
		  this.insertAfter(f, this.fields[this.fields.length - 1]);
		this.fields.push(f); 
	 }
	 else
	 {
		
		var f = JSL.Rgx.Group.Field(this.fields.length);
		if (!this.fields.length)
		  this.appendChild(f);
		else
		  this.insertAfter(f, this.fields[this.fields.length - 1]);
		this.fields.push(f);  
	 }
  };
  

// Remove field from group
JSL.Rgx.Group.removeField = 
  function(f) {
	var grpno,flag=false;
    var a = this.fields;
	console.log('removeField');
	console.log(a);
    var l = a.length;
    for(var i=0; i<l; i++) {
      if (a[i] == f)
	  {
		grpno =  a[i].groupinput.id;
        break;
	  }
    }
	
    for(var j=i; j<l-1; j++) {
      a[j] = a[j + 1];
	  var id = a[j].input.id;
	  grpno =  a[j].groupinput.id;
	  console.log('grpno:'+grpno);
	  var res = id.split('_');
	  console.log(res[0]);
	  var newid=res[0]+'_'+(j + 1);
	  a[j].input.id = newid;
	  id =a[j].childNodes[4].id;
	  res = id.split('_');
	  newid=res[0]+'_'+(j + 1);
	  console.log(newid);
	  a[j].childNodes[4].id=newid;
      a[j].firstChild.nodeValue = 'Field ' + (j + 1);
	  flag=true;
    }
	 if(flag==true)
	 {
	 	document.getElementById('group'+grpno).value = parseInt(document.getElementById('group'+grpno).value) - 1;
	 }
	 else
	 {
		 
		 document.getElementById('group'+grpno).value = parseInt(document.getElementById('group'+grpno).value) - 1;
		 
	 }
	console.log(this);
	//console.log('f:'+f.id);
	//$('#'+f.id).remove();
    this.removeChild(f);
    a.pop()
    this.parentNode.update();
  };

// Get value of group
// i is the group index used to get the color
JSL.Rgx.Group.getValue =
  function(n) {
    // Color to match tab color
    var color = JSL.Rgx.colors[n % JSL.Rgx.colors.length];
    this.rgx = '';
    var s = '';
    // If the regex is ending remember for later
    if (/\$/.test(this.begin.value))
      this.parentNode.end = '<span onclick="JSL.Rgx.selectTabByIndex(event, ' + n + ');" title="Group ' + (n + 1) + '" + style="cursor: pointer; color:' + color + '">$</span>';
    // Get field values
    var a = this.fields;
    var l = a.length;
    var tmp;
    for(var i=0; i<l; i++) {
      tmp = a[i].getValue();
      if (!tmp)
        continue;
      if (i && this.rgx)
        this.rgx += '|';
      this.rgx += tmp;
    }
    // Get quantifier if field has any input besides start and end
    if (this.rgx) {
      // If qty applies to entire group
      if (this.qtyGroup && this.qty && this.rgx.length > 1)
        this.rgx = '(?:' + this.rgx + ')' + this.qty;
      else
        this.rgx += this.qty;
    }
    // If this group is a forward assertion
    if (this.rgx.length && /\?/.test(this.begin.value))
      this.rgx = '(?<=' + this.rgx + ').*';
    // Else if this group is a negated forward assertion
    else if (this.rgx.length && /\!/.test(this.begin.value))
      this.rgx = '(?!' + this.rgx + ')';
    // If capture or group
    if (this.rgx.length) {
      if (this.capture)
        this.rgx = '(' + this.rgx + ')';
      else if (this.qtyGroupFields && this.rgx.length > 1)
        this.rgx = '(?:' + this.rgx + ')';
    }
    // Get value from beginning select box
    if (/\^/.test(this.begin.value))
      this.rgx = '^' + this.rgx;
    // Else if this is a logical OR group
    else if (this.rgx.length && /\|/.test(this.begin.value))
      this.rgx = '|' + this.rgx;
    s = '<span onclick="JSL.Rgx.selectTabByIndex(event, ' + n + ');" title="Group ' + (n + 1) + '" + style="cursor: pointer; color:' + color + '">' + this.rgx + '</span>';
    return s;
  };

// Get regex as human readable text
JSL.Rgx.Group.getText =
  function(n) {
    // Color to match tab color
    var color = JSL.Rgx.colors[n % JSL.Rgx.colors.length];
    // Get text of select
    var s = '<span onclick="JSL.Rgx.selectTabByIndex(event, ' + n + ');" title="Group ' + (n + 1) + '" + style="cursor: pointer; color:' + color + '">' + this.begin.options[this.begin.selectedIndex].text;
    // Get qauntifier text - the not so clever way
    var m = null;
    // Get field text
    var a = this.fields;
    var l = a.length;
    var tmp;
    var rgx = '';
    for(var i=0; i<l; i++) {
      tmp = a[i].getText();
      if (tmp.length) {
        // If not first field and some regex is entered add 'or'
        if (i && rgx)
          s += ' or';
        // If only spaces
        if (/^\s+$/.test(tmp))
          s += ' <strong>' + tmp.length + ' space' + (tmp.length > 1 ? 's' : '') + '</strong>';
        // if character class
        else if (!a[i].freeInput)
          s += ' <strong>' + tmp + '</strong>';
        // if single character
        else if (tmp.length == 1) {
          s += ' the character <strong>' + tmp + '</strong>';
        }
        // if free string
        else {
          // if this is the last field, string length is more than 1
          // and quantifier applies to last char
          if (i == l - 1 && tmp.length > 1 && !this.qtyGroup && this.qtyText) {
            var p = tmp[tmp.length - 1];
            var r = tmp.substring(0, tmp.length - 1);
            if (r.length > 1)
              s += ' the string <strong>' + r + '</strong>';
            else
              s += ' the character <strong>' + r + '</strong>';
            s += ' followed by the character <strong>' + p + '</strong>';
          }
          else
            s += ' the string <strong>' + tmp + '</strong>';
        }
        rgx += tmp;
      }
    }
    if (rgx)
      s += ' ' + this.qtyText;
    s += '</span><br />';
    // Get quantifier text
    return s;
  };


/*********************************************
*
*   JSL.Rgx.Group.Field
*
**********************************************/

JSL.Rgx.Group.Field =
  function(n , groupnum , obj) {
	  countRegexTxt = countRegexTxt + 1;
	  countFreeTxt = countFreeTxt + 1;
	  console.log('JSL.Rgx.Group.Field' + GroupNumber);
	  //console.log(this);
	  var grpNo;
	  if(typeof groupnum !== "undefined")
	  {
		 grpNo= groupnum;
	  }
	  else
	  {
		  grpNo = GroupNumber;
	  }
	  var fieldNo = document.getElementById('group'+grpNo);
	  console.log('fieldNo:'+fieldNo);
	  if(fieldNo == null)
	  {
		  var input = document.createElement('input');
   		  input.type = 'hidden';
		  input.value = 1;
		  input.id = 'group'+grpNo;
	      $("#content").append(input);
		  console.log('Hidden Input Appended');
	  }
	   if(typeof obj !== "undefined" && typeof groupnum !== "undefined" && typeof n !== "undefined")
	  {
		  
		// Container
		var div = document.createElement('div');
		div.appendChild(document.createTextNode('Field ' + (n + 1)));
		div.appendChild(document.createElement('br'));
		div.freeInput = true;
		// Methods
		div.getValue = JSL.Rgx.Group.Field.getValue;
		div.getText = JSL.Rgx.Group.Field.getText;
		// Input
		 
		div.input = document.createElement('input');
		
		var groupNo;
		var index;
		console.log('groupnum:'+groupnum);
		if(typeof groupnum !== "undefined")
		 {
			
			 console.log('groupnum:'+groupnum);
			 var index = document.getElementById('group'+groupnum).value; 
			 groupNo=groupnum-countRemovedGroup;
			 document.getElementById('group'+groupnum).value = parseInt(document.getElementById('group'+groupnum).value) + 1;
		 }
		 else
		 {
			 groupNo = GroupNumber;
			 var index = document.getElementById('group'+GroupNumber).value; 
			 document.getElementById('group'+GroupNumber).value = parseInt(document.getElementById('group'+GroupNumber).value) + 1;
		 }
		div.input.id ='RegexText'+groupNo +'_'+index;
		div.input.style.width = '240px';
		div.input.style.marginRight = '2px';
		div.groupinput = document.createElement('input');
		div.groupinput.id =groupNo;
		div.groupinput.type='hidden';
		div.appendChild(div.groupinput);
		div.id='div'+groupNo +'_'+index;
		 if(obj != null)
		{
			if(obj.Name.indexOf("000000") > -1)
			{
				div.input.setAttribute('value',"");
			}
			else
			{
				div.input.setAttribute('value',obj.Name);
			}
		}
		
		div.appendChild(div.input);
		 // Update on keydown
		div.onkeyup = JSL.Rgx.Group.Field.onkeyup;
		var select = document.createElement('select');
		select.id = 'FreeText'+groupNo +'_'+index;;
		select.style.verticalAlign = 'middle';
		select.style.marginRight = '2px';
		select.onchange = JSL.Rgx.Group.Field.changeClass;
		select.add(new Option('Free text',''), null);
		select.add(new Option('any character','.'), null);
		select.add(new Option('any letter a-z','[a-zA-Z]'), null);
		select.add(new Option('any lowercase letter a-z','[a-z]'), null);
		select.add(new Option('any uppercase letter A-Z','[A-Z]'), null);
		select.add(new Option('any digit 0-9','\\d'), null);
		select.add(new Option('any ASCII word character','\\w'), null);
		select.add(new Option('any whitespace','\\s'), null);
		select.add(new Option('any word boundary','\\b'), null);
		//select.add(new Option('custom class','[]'), null);
		 /*if(obj != null)
		{
			for(var i =1 ; i <select.length ; i++)
			{
				if(select.options[i].label.localeCompare(obj.ortoo_e2a__Free_text__c) == 0)
				{
					 //select.options[i].selected = true;
					 freeTxtIdList[freeTxtIdCount] = select.id;
					 freeTxtIdCount = freeTxtIdCount + 1;
					
					break;
					
				}
			}
		}*/
		div.appendChild(select);
		
		// Button for adding/removing field
		 var grpno = GroupNumber;
		var input = document.createElement('input');
		input.id = 'input'+groupNo +'_'+index;
		input.type = 'button';
		if (!n) {
		  input.value = 'Add field';
		  input.onclick = function(e) {div.parentNode.addField(grpno);};
		}
		else {
		  console.log('n:'+n);
		  console.log(div.parentNode);
		  input.value = 'Remove field';
		 /* input.onclick = function(e) {
			 var group = document.getElementsByClassName('group');
			 // div.parentNode.removeField(div);
			 console.log(group);
			for(var i=0;i<group.length;i++)
			{
				//freeTxtList[i].update();
				group[i].removeField(div);
			}
			 
			 };*/
		input.onclick = function(e) {div.parentNode.removeField(div);};
		  
		}
		div.appendChild(input);
		return div;
	  }
	  else
	  {
		   
		  // Container
    var div = document.createElement('div');
    div.appendChild(document.createTextNode('Field ' + (n + 1)));
    div.appendChild(document.createElement('br'));
    div.freeInput = true;
    // Methods
    div.getValue = JSL.Rgx.Group.Field.getValue;
    div.getText = JSL.Rgx.Group.Field.getText;
    // Input
	div.input = document.createElement('input');
	var groupNo;
	var index;
	console.log('groupnum:'+groupnum);
	if(typeof groupnum !== "undefined")
	 {
		
		 var index = document.getElementById('group'+groupnum).value; 
		 groupNo=groupnum-countRemovedGroup;
		 document.getElementById('group'+groupnum).value = parseInt(document.getElementById('group'+groupnum).value) + 1;
	 }
	 else
	 {
		 groupNo = GroupNumber;
		 var index = document.getElementById('group'+GroupNumber).value; 
		 document.getElementById('group'+GroupNumber).value = parseInt(document.getElementById('group'+GroupNumber).value) + 1;
	 }
		 // Update on keydown
	 div.groupinput = document.createElement('input');
	 div.groupinput.type='hidden';
		div.groupinput.id =groupNo;
		div.appendChild(div.groupinput);
		
	div.input.id ='RegexText'+groupNo +'_'+index;
	//div.input.id ='RegexText'+countRegexTxt;
	div.input.style.width = '240px';
	div.input.style.marginRight = '2px';
	//div.input.setAttribute('value','final');
    div.appendChild(div.input);
	div.id='div'+groupNo +'_'+index;
	 
    div.onkeyup = JSL.Rgx.Group.Field.onkeyup;
    var select = document.createElement('select');
	select.id = 'FreeText'+groupNo +'_'+index;;
    select.style.verticalAlign = 'middle';
    select.style.marginRight = '2px';
    select.onchange = JSL.Rgx.Group.Field.changeClass;
    select.add(new Option('Free text',''), null);
    select.add(new Option('any character','.'), null);
    select.add(new Option('any letter a-z','[a-zA-Z]'), null);
    select.add(new Option('any lowercase letter a-z','[a-z]'), null);
    select.add(new Option('any uppercase letter A-Z','[A-Z]'), null);
    select.add(new Option('any digit 0-9','\\d'), null);
    select.add(new Option('any ASCII word character','\\w'), null);
    select.add(new Option('any whitespace','\\s'), null);
    select.add(new Option('any word boundary','\\b'), null);
    //select.add(new Option('custom class','[]'), null);
    div.appendChild(select);
    
    var grpno = GroupNumber;
	// Button for adding/removing field
    var input = document.createElement('input');
	input.id = 'input'+groupNo +'_'+index;
    input.type = 'button';
    if (!n) {
      input.value = 'Add field';
      input.onclick = function(e) {div.parentNode.addField(grpno);};
    }

    else {
	    console.log('n:'+n);
		  
      input.value = 'Remove field';
      input.onclick = function(e) {div.parentNode.removeField(div);};
	  console.log(div.parentNode);
	  var freeTxtList = document.getElementsByClassName('regex');
		   console.log(freeTxtList);
	  console.log(div);
    }
    div.appendChild(input);
    return div;
	  }
	  
  };
  

// Beginning of group
JSL.Rgx.Group.Field.Begin =
  function(n) {
    var select = document.createElement('select');
    select.id = 'selectlist'+n;
	if(n==1)
	{
		select.style.marginTop = '30px';
		select.style.marginLeft = '-120px';
	}
	else
	{
		select.style.marginTop = '30px';
		select.style.marginLeft = '-180px';
	}
    if (n < 2) {
      select.add(new Option('Match a string which contains',''), null);
      select.add(new Option('Match a string which starts with','^'), null);
      select.add(new Option('Match a string which ends in','$'), null);
      select.add(new Option('Match a string which starts and ends in','^$'), null);
      select.add(new Option('Match a string that comes after','?'), null);
    }
    else {
      select.add(new Option('followed by',''), null);
      select.add(new Option('or','|'), null);
      select.add(new Option('only if followed by','?'), null);
      select.add(new Option('only if not followed by','!'), null);
      select.add(new Option('ending in','$'), null);
    }
    select.onchange = JSL.Rgx.Group.Field.Begin.onchange;
    return select;
  };

// Call update of regex
JSL.Rgx.Group.Field.Begin.onchange =
  function(e) {
    this.parentNode.parentNode.update();
  };

JSL.Rgx.Group.Field.onkeyup =
  function(e) {
    e.target.parentNode.parentNode.parentNode.update();
  };

// Get value of single field
JSL.Rgx.Group.Field.getValue =
  function() {
    // Replace regex identifiers if free input
    if (this.freeInput)	
      return this.input.value.replace(/[\^\$\.\*\+\?\=\!\:\|\(\)\[\]\{\}\\\/]/g,function($0){return '\\' + $0;});
    else
      return this.input.nextSibling.value;
  };

// Get text from field
JSL.Rgx.Group.Field.getText =
  function() {
    // If free input
    return this.input.value;
  };

JSL.Rgx.Group.Field.changeClass =
  function(e) {
	  //console.log(this);
	if (this.value) {
      this.previousSibling.value = this.options[this.selectedIndex].text;
      this.previousSibling.disabled = true;
      this.parentNode.freeInput = false;
    }
    else {
	  
      this.previousSibling.value = '';
      this.previousSibling.disabled = false;
      this.parentNode.freeInput = true;
    }
	
	/*console.log(e);
	console.log(e.target);
	console.log(e.target.parentNode);
	console.log(e.target.parentNode.parentNode);
	console.log(e.target.parentNode.parentNode.parentNode);*/
	
	/*if(typeof freeTextValueList !== "undefined")
	{
		if(freeTextValueList.length > 0)
		{
		var freeTxtList = document.getElementsByClassName('regex');
		
		
		//console.log(document.getElementsByClassName('regex'));
		//console.log(document.getElementById('content').innerHTML);
		//console.log('Length: '+freeTxtList.length);
		for(var i=0;i<freeTxtList.length;i++)
		{
			freeTxtList[i].update();
		}
		}
	}*/
	var freeTxtList = document.getElementsByClassName('regex');
		
		
		//console.log(document.getElementsByClassName('regex'));
		//console.log(document.getElementById('content').innerHTML);
		//console.log('Length: '+freeTxtList.length);
		for(var i=0;i<freeTxtList.length;i++)
		{
			freeTxtList[i].update();
		}
	//else
	//{
		//e.target.parentNode.parentNode.parentNode.update();
	//}
	//e.target.parentNode.parentNode.parentNode.update();
	//console.log(document.querySelectorAll('.regex'));
	//e.target.parentNode.parentNode.parentNode.update();
	

	
  };

function RecentItemRegex()
{
	ortoo_e2a.RegexGeneratorController.GetRecentItems(function(result, event){
		var ele = '<br/><h2><u>Recent Regex:</u></h2><br/>'+
				'<ul id="recentRegex" style="list-style-type: none;margin: 0;padding: 0;overflow: hidden;">';
		var counter =1;
		$.each(result,function(){
			ele += '<li style="float: left;"><a style="display: block;" href="#" onclick="RecentItemClick(\''+this.RecordId+'\');">'+decodeHTMLEntities(this.Pattern)+',</a></li>';
			counter ++;
		});
		ele += '</ul>';
		
		console.log(ele);
		$("#content").append(ele);

	});
}

function getCurrentUser()
{
	$(document).ready(function(){
		ortoo_e2a.RegexGeneratorController.GetCurrentUserId(function(result, event){
			var div = document.createElement('div');
			div.id = 'currentuserId';
			div.style.display = 'none';
			div.appendChild(document.createTextNode(result));
			$("#content").append(div);
		});
	});
}

function RecentItemClick(RecordId)
{
	console.log('onclick:'+RecordId);
	// Define utility methods
	  if (document.createEventObject && !window.EPE) {
	    alert('This script uses JDC to run in Internet Explorer. Currently only IE 6 and 7 are supported by JDC. When IE 8 gets out of beta we\'ll have a look at that too.');
	    return;
	  }
	  HTMLElement.prototype.insertAfter =
	    function(nC, rC) {
	      rC.nextSibling ? rC.parentNode.insertBefore(nC, rC.nextSibling) : rC.appendChild(nC);
	    };
	
		freeTxtIdList = new Array();
		freeTxtIdCount = 0;
		FieldValueList = new Array();
		followedByValueList = new Array();
		freeTextValueList = new Array();
		countRegexTxt = 0;
		countFreeTxt = 0;
		GroupNumber = 0;
		countRemovedGroup = 0;
	  //var rgx = JSL.Rgx();
	  var rgx = JSL.Rgx(RecordId);
	  
	  document.getElementById('content').innerHTML = '';
	  document.getElementById('content').appendChild(rgx);
	 
	  getCurrentUser();
	   
	  // Now make first radio in first group selected in IE
	  if (document.createEventObject)
	  {
	    document.getElementById('qty1_0').checked = true;
		
		
	  }
}

function main(e) {
  // Define utility methods
  if (document.createEventObject && !window.EPE) {
    alert('This script uses JDC to run in Internet Explorer. Currently only IE 6 and 7 are supported by JDC. When IE 8 gets out of beta we\'ll have a look at that too.');
    return;
  }
  HTMLElement.prototype.insertAfter =
    function(nC, rC) {
      rC.nextSibling ? rC.parentNode.insertBefore(nC, rC.nextSibling) : rC.appendChild(nC);
    };
  var rgx = JSL.Rgx();
  document.getElementById('content').appendChild(rgx);
   getCurrentUser();
  // Now make first radio in first group selected in IE
  if (document.createEventObject)
    document.getElementById('qty1_0').checked = true;
	
 }

function decodeHTMLEntities(text) {
	    var entities = [
	        ['apos', '\''],
	        ['amp', '&'],
	        ['lt', '<'],
	        ['gt', '>']
	    ];
	
	    for (var i = 0, max = entities.length; i < max; ++i) 
	        text = text.replace(new RegExp('&'+entities[i][0]+';', 'g'), entities[i][1]);
	
	    return text;
	}
window.onload = main;