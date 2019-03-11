fieldset {border:0; display:inline; padding:10px; vertical-align:top;}
.primaryPalette {background-color:#ec7039 !important;}
.brdPalette, .secondaryPalette {border-top-color:#ec7039!important;}

.slds-scope {
	padding:0;
}

/** Full Screen Overlay **/
.slds-backdrop {
	background: rgba(255,255,255,.8) !important;
}

.slds-backdrop .slds-spinner {
    position:static !important;
}

/** Buttons **/
.slds-button_brand {
	border: 1px solid #ec7039 !important;
	background-color: #ec7039 !important;
}

.slds-button_brand[disabled] {
	background: #e0e5ee !important;
	border-color: transparent!important;
	color: #fff !important;
}

.slds-scope .slds-section__title {
	color: white !important;
	background-color: #ec7039 !important;
	border-top: 0 !important;
}

.slds-scope .slds-table {
    background-color: transparent;
}

/** Select **/
.slds-select_container::before {
    content: none !important;
}

.slds-select_container::after {
    border-top-width: 6px !important;
    border-left-width: 3px !important;
    border-right-width: 3px !important;
    bottom: 0.85rem !important;
}


/** Section **/
.slds-section__title-action,.slds-section__title-action:hover,.slds-section__title-action:focus{
	background-color: #ec7039 !important;
}

.slds-tabs_default__item.slds-has-focus,.slds-tabs_default__item.slds-is-active  {
	color: #e96e25 !important;
}

.slds-tabs_default__item.slds-is-active:after,.slds-tabs_default__item.slds-has-focus:after,.slds-scope .slds-tabs_default__item:hover:after {
	background-color: #e96e25 !important;
}

.btn.slds-button.slds-button_neutral:focus {
    outline: 0;
    box-shadow: 0 0 3px #0070D2;
}

.btn.slds-button.slds-button_neutral:active {
	border:1px solid rgb(216, 221, 230) !important;
	color: #005fb2 !important;
}

/* Tooltips */
.tooltip {
    position: relative;
    display: inline-block;
}

.tooltip .tooltiptext {
    visibility: hidden;
    width: 275px;
    position:absolute;
}

.slds-popover {
    text-align:left;
}

.tooltip:hover .tooltiptext {
    visibility: visible;
}

.tooltip-button:focus {
    border-radius: 16px;
}

.tooltip-button {
	background-position: -1px -1px !important;
	width: 14px;
    height: 14px;
    background-size: 14px 28px !important;
}

.tooltip-button:hover,:focus {
	background-position: -15px -15px !important;
}

.tooltip-button:focus + .tooltiptext {
    visibility: visible;
}

.tooltip_top {
    left:-121%;
    bottom:145%;
}



/** Checkbox **/
.slds-checkbox_faux:after {
	border-bottom: 2px solid #ec7039 !important;
    border-left: 2px solid #ec7039 !important;
}

/** Radio **/
.slds-radio_faux:after {
	background: #ec7039 !important;
}

/* Style uiButtons (e.g. Analytics Report Charts)*/
.uiButton--default {
	color: #0070d2 !important;
	border: 1px solid #d8dde6 !important;
	background-color: #ffffff !important;
	padding-left: 1rem !important;
	padding-right:1rem !important;
	text-align: center !important;
	vertical-align: middle !important;
	background: none !important;    
	box-shadow: none !important;
	text-shadow: none !important;
	text-decoration: none !important;
	border-radius: 0.25rem;
}

.uiButton--default .label {
	color: #0070d2 !important;
}

.uiButton--default:hover .label {
	color: #005fb2 !important;
}

.uiButton--default:hover, .uiButton--default:focus{
	color: #005fb2 !important;
	background-color: #f4f6f9 !important; 
	outline: 0 !important; 
}

.uiButton--default:focus {
	box-shadow: 0 0 3px #0070D2 !important;  
}

/* Font Styling */
.bold {
    font-weight: bold;   
}

.italic {
    font-style: italic;
}

/* Date Picker */

.datePicker {
	background-color: #ffffff;
	background-image:none;
}

.dateBar select {
	border-radius: .25rem;
}

.dateBar select:focus {
	outline: 0 !important;
	border-color: #1589ee !important;
	background-color: #fff !important;
}

.datePicker .calDays .weekend, .datePicker .calDays .weekday {
    background: none;
    border: 0 !important;
    padding: 2px 0 !important;
    width: 2rem !important;
    height: 2rem !important;
    border-radius: 50% !important;
    margin: auto !important;
    font-weight:normal !important;
}

.datePicker .calDays .todayDate {
	background: none !important;
	color: black !important;
}

.datePicker .calDays .selectedDate {
    background-color: #005fb2 !important;    
    color: white !important;
}

.datePicker .calDays .highlight {
	background: none;
}

.calButton {
    height:16px !important;
    width:16px !important;
    margin-top:2px !important;
    margin-right:10px !important;
    margin-left:10px !important;
}

.dateBar {
	padding-top: 4px !important;
}

.slds-form-element__label {
    font-weight:700;
}

.instruction_row {
    display: flex;
    flex-direction: row;
}

.instruction_text_container, .instruction_img_container {
    -webkit-flex: 1; /* Safari 6.1+ */
    -ms-flex: 1; /* IE 10 */ 
    flex: 1;
}

.instruction_row:not(:first-child) {
    margin-top:1.5rem;
}

.seeMore div {position:relative; cursor: default;}
.seeMore div span {display: none; z-index:90;}

.seeMore div div:hover span {
    display: block;position:absolute;
    top:1em; padding:5px; left:5em; width:30em; border:1px solid #ff8100; z-index: 9999 !important;
    background-color:#fff7ee; color:black;
} 

.primaryPalette {background-color:#D36D00 !important;}
.brdPalette, .secondaryPalette {border-top-color:#D36D00 !important;}

.pbSubheader { 
    background: #e96e25 !important; /* Fallback to solid color for older browsers */ 
    background-image: linear-gradient(to top, #b95e15, #f97e35) !important; 
    border-radius: 4px; 
    text-shadow: -1px 0 #b95e15, 0 1px #b95e15,1px 0 #b95e15, 0 -1px #b95e15; 
    user-select: none;
    -ms-user-select: none;
    -moz-user-select: none;
    -webkit-user-select: none;
    cursor: pointer;
} 
        
.pbSubheader img {
    outline: none !important;
}

.pageTitleIcon { 
   /* background-image: url(/img/icon/wrench32.png) !important; */ /* Change this URL to point to the icon you want to use */ 
} 

.historySettingIndent {
    margin-left: 32px;
}

.disabled {
    color: #999 !important;
}

.bootstrap-tagsinput {
    width: 50%;
}

span.tag.label.label-info {
    color: white;
    background: #DD5D0D;
    border-radius: 2.5px;
    padding: 2px;
}

#std-sec, #e-sec, #pg\:frm\:pbInitialSetup\:Setup\:stdUiPermsImg, #pg\:frm\:pbInitialSetup\:Setup\:enUiPermsImg {
    display: none;
}
#sel-sec {
    margin-left: 0px;
    list style-type: none;
    display: table;
}
#sel-sec li {
    display: table-cell;
    cursor: pointer;
    border-radius: 4px;
    width: 316px;
    margin-right: 4px;
}
#sel-sec li:hover {
    background-color: #f97e35;
}
#sel-sec li input[type=radio] {
    cursor: pointer;
}
#sel-sec li img {
    max-width: 300px;
    margin: 8px;
    box-shadow: 4px 4px 4px #999;
}