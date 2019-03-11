/* CSS Table of Contents

- Main CSS
- Header
- Nav - Portal Picker
- Portal Picker Drop Down Menu
- Side Nav
- App Boxes - main partner portal apps
- Portal Colors
- App Buttons
- Info Boxes
- Dashboard Tables
- Breadcrumbs
- Product Tree List
- Product Results
- Documents Table
- Footer
- Wizard Styles
- Global Styles
- Dealer Results for Where to Buy
- Forms
- Where to Buy
- CSS Boilerplate 

---------------------------------------------------- */

* {
    margin:0;
    padding:0;
    box-sizing:border-box;
    -moz-box-sizing:border-box;
}

html, body {
    height:100%;
}

body {
    font-family: sans-serif;
    background:#f3f3f3;
    font-size:80%;
}

.wrapper {
  min-height: 100%;

  /* Equal to height of footer */
  /* But also accounting for potential margin-bottom of last child */
  margin-bottom: -120px;
}

h1, h2, h3, h4, p, li {
    margin-bottom:15px;
    line-height:normal;
}

p, li, a {
    color:#555;
    line-height:125%;
}

h1, h2, h4 {
    font-weight:lighter;
}

h1 {
    font-size:1.7em;
    padding-bottom:10px;
}

h2 {
    font-size:1.5em;
    font-weight:lighter;
    color:#666;
}

h3 {
    font-size:1.3em;
    font-weight:lighter;
}

h4 {
    font-size:1em;
    font-weight:bold;
}

hr {
    border: 0;
    height: 0;
    border-top: 1px solid #ccc;
    border-bottom: 1px solid #fff;
    margin:20px 0;
}

a {
    color:#1f83ad;
}

ul {
    list-style-position: inside;
    margin-bottom:20px;
}

li {
    padding:0px 0px 5px 0px;
    margin:0;
}

/* Header 
---------------------------------------------------- */

.header {
    color:#fff;
    height:60px;
}

.header-partner-portal {
    background:#cc0000;
}

.header-mvb-manger {
    background:#055588;
}

.header .menu-icon {
    min-width:130px;
    height:60px;
}

.header .no-menu-icon {
    min-width:80px;
    height:60px;
}

.header .menu-icon a,
.header .no-menu-icon a {
    color:#fff;
}

.header h1 {
    font-weight: normal;
    font-size:1.75em;
    text-shadow: 2px 2px 0 rgba(0, 0, 0, 0.2);
    display: inline-block;
    letter-spacing: .03em;
}

.header h1 a {
    color:#fff;
    text-decoration: none;
}

.header .logo {
    height:60px;
    width:130px;
}

.header img.kvh-logo {
    width:100%;
    height:auto;
}

.header i {
    padding:0 10px;
}

.header .user {
    height:60px;
}

.header .tag {
    background:rgba(0,0,0,.12);
    margin-left:10px;
    color:#fff;
    padding:5px 10px;
    border-radius:10px;
}

@media only screen and (max-width: 700px) {
    .user {
        display: none;
    }
    
    .logo {
        display:none;
    }
}

.simple-header {
    height:60px; 
    padding:15px 25px;
}

/* Nav - Portal Picker
---------------------------------------------------- */

nav {
    text-align: left;
    padding:15px 20px;
    background:#444;
}

    @media (max-width: 600px) {
        nav {
            text-align:center;
        }
    }

.view {
    color:#ddd; 
    padding-right:10px; 
    display:inline;
}

    @media (max-width: 500px) {
        .view {
            display:none;
        }
    }


/* Portal Picker Drop Down Menu - https://tympanus.net/codrops/2012/10/04/custom-drop-down-list-styling/
---------------------------------------------------- */

.wrapper-dropdown-3 {
    position: relative;
    margin: 0;
    padding: 5px 10px;
    z-index: 1000;
    border-radius: 10px;
    cursor: pointer;
    outline: none;
    display:inline-block;
    min-width: 275px;
}

.wrapper-dropdown-3:after {
    content: "";
    width: 0;
    height: 0;
    position: absolute;
    right: 15px;
    top: 50%;
    margin-top: -3px;
    border-width: 6px 6px 0 6px;
    border-style: solid;
    border-color: #fff transparent;
}

.wrapper-dropdown-3 .dropdown {
    position: absolute;
    top: 140%;
    left: 0;
    right: 0;
    background: white;
    border-radius: inherit;
    font-weight: normal;
    -webkit-transition: all 0.5s ease-in;
    -moz-transition: all 0.5s ease-in;
    -ms-transition: all 0.5s ease-in;
    -o-transition: all 0.5s ease-in;
    transition: all 0.5s ease-in;
    list-style: none;
    opacity: 0;
    pointer-events: none;
    box-shadow: 3px 3px 3px rgba(0,0,0,.1);
}

.wrapper-dropdown-3 .dropdown:after {
    content: "";
    width: 0;
    height: 0;
    position: absolute;
    bottom: 100%;
    right: 15px;
    border-width: 0 6px 6px 6px;
    border-style: solid;
    border-color: #fff transparent;    
}

.wrapper-dropdown-3 .dropdown:before {
    content: "";
    width: 0;
    height: 0;
    position: absolute;
    bottom: 100%;
    right: 13px;
    border-width: 0 8px 8px 8px;
    border-style: solid;
    border-color: rgba(0,0,0,0.1) transparent;    
}

.wrapper-dropdown-3 .dropdown li a {
    display: block;
    text-decoration: none;
    color: #555;
    padding:0 15px;
    box-shadow: inset 0 1px 0 rgba(255,255,255,1);
    -webkit-transition: all 0.3s ease-out;
    -moz-transition: all 0.3s ease-out;
    -ms-transition: all 0.3s ease-out;
    -o-transition: all 0.3s ease-out;
    transition: all 0.3s ease-out;
}

.wrapper-dropdown-3 .dropdown li:first-of-type a {
    border-radius: 10px 10px 0 0;
    padding-top:15px;
}

.wrapper-dropdown-3 .dropdown li:last-of-type a {
    border: none;
    border-radius: 0 0 10px 10px;
}

/* Hover state */

.wrapper-dropdown-3 .dropdown li:hover a {
    color:#1f83ad;
}

/* Active state */

.wrapper-dropdown-3.active .dropdown {
    opacity: 1;
    pointer-events: auto;
}

/* No CSS3 support */

.no-opacity       .wrapper-dropdown-3 .dropdown,
.no-pointerevents .wrapper-dropdown-3 .dropdown {
    display: none;
    opacity: 1; /* If opacity support but no pointer-events support */
    pointer-events: auto; /* If pointer-events support but no pointer-events support */
}

.no-opacity       .wrapper-dropdown-3.active .dropdown,
.no-pointerevents .wrapper-dropdown-3.active .dropdown {
    display: block;
}

.sales-aids {
    float:right;
    background-color:rgba(0, 0, 0, 0.3);
    border-radius: 13px;
    padding:6px 15px;
}

.sales-aids a {
    color:#ddd;
    padding:0px 10px 0 0;
    text-decoration: none;
}


/* side nav 
---------------------------------------------------- */

/* The side navigation menu */
.sidenav {
    height: 100%;
    width: 0; /* 0 width - change this with JavaScript */
    position: fixed;
    z-index: 100000;
    top: 0;
    left: 0;
    background-color: #333;
    overflow-x: hidden; /* Disable horizontal scroll */
    padding-top: 20px; /* Place content 60px from the top */
    transition: 0.5s; /* 0.5 second transition effect to slide in the sidenav */
    font-weight:lighter;
}

.sidenav ul {
    padding:20px;
}

.sidenav li {
    margin:40px 0;
    padding-left:10px;
    font-size:110%;
}

.sidenav i {
    color:#ccc;
}

.sidenav a {
    text-decoration: none;
    color: #ccc;
    display: block;
    transition: 0.3s;
}

.sidenav a:hover, .offcanvas a:focus{
    color: #fff;
}

/* Position and style the close button (top right corner) */
.sidenav .closebtn {
    position: absolute;
    top: 0;
    right: 10px;
    font-size: 36px;
    margin-left: 50px;
}

/* On smaller screens, where height is less than 450px, change the style of the sidenav (less padding and a smaller font size) */
@media screen and (max-height: 450px) {
    .sidenav {padding-top: 15px;}
}



/* App Boxes - main partner portal apps
---------------------------------------------------- */

.app-box {
    color:#fff;
    text-align: center;
}

.app-box h1 {
    margin:0 0 10px 0;
    padding:0;
}

.app-box h4 {
    margin:5px 0;
}

.app-box p {
    color:rgba(255,255,255,.7);
    margin:10px auto;
}

.app-box .icon-background {
    color: rgba(255,255,255,.3);
}

.app-box a.button {
    color:#fff;
    margin: 0;
    background:rgba(255,255,255,.3);
    border:0;
    bottom:20px;
    left:40%;
    padding-left:30px;
    padding-right:30px;
}

.app-box hr, .info-box hr {
    margin:50px 0 0 0;
    padding:0;
    border:none;
}


/* Portal Colors 
---------------------------------------------------- */

.leisure-marine {
    background-color: #2b879e;
}

.leisure-land {
    background-color: #11a183;
}

.comm-marine {
    background-color: #206796;
}

.comm-land {
    background-color: #107857;
}

.comm-fog {
    background-color: #e79326;
}

/* App Buttons 
---------------------------------------------------- */
.app-button {
    color:#555;
    text-align: left;
    overflow: auto;
    border-radius:3px;
    margin:20px;
    background:#fff;
}

    @media (max-width: 900px) {
        .app-button {
            margin:10px 10px 20px 10px;
        }
    }

.app-button h1, .app-button h2 {
    color:#cc0000;
    margin:0;
    padding:0;
}

.app-button h3 {
    margin:0;
    padding:0;
}

.icon-side {
    width:15%;
    background:#ccc; 
    float:left; 
    height:100%; 
    color:#fff;
    padding:15px;
}

.app-content {
    width:85%;
    float:right;
    padding:15px;
}

    @media (max-width: 1200px) {
        .icon-side i {
            font-size:125%;
        }
    }

    @media (max-width: 1000px) {
        .icon-side {
            display:none;
        }

        .app-content {
            width:100%;
            float: none;
        }
    }


/* Info Boxes - News, Events, Spotlight 
---------------------------------------------------- */

.info-box {
    margin:15px;
    background:#fff;
}

    @media (max-width: 900px) {
        .info-box {
            margin:10px;
        }
    }

.info-box h2, .info-box h3, .info-box h4 {
    padding:10px 15px;
    margin:0;
    background:#e3e3e3;
    color:#666;
}

.info-box h5 {
    color: #1f83ad;
    font-weight:bold;
    padding-bottom:5px;
    font-style:italic;
    font-size:1em;
}

.info-box .content {
    padding:10px;
}

.info-box button {
    padding:3px 5px;
    border-radius:12px;
    background:#fff;
    border: none;
    outline:none;
    cursor: pointer;
}

.info-box li {
    padding-bottom:10px;
}

.info-box .banner {
    border-radius: 3px; 
    width:100%; 
    height:auto;
    max-width:400px;
}

/* boxes with dark headers 
---------------------------------------------------- */

.dark-box h2 {
    color:#fff;
    margin:0;
}

.dark-box-title {
    background:#444444;
    padding:15px;
    text-align:center;
}

.dark-box-title img {
    width:13%;
    height:auto;
    display:block;
    margin:0 auto 10px auto;
}

.dark-box .content {
    padding:20px;
    overflow: auto;
}

.dark-box a.button {
    border:1px solid #ddd;
    border-radius:3px;
    padding:10px 20px;
    display:block;
    text-align: center;
    text-decoration: none;
    margin-bottom:20px;
    font-size:1em;
}

.dark-box a.button:hover {
    background:#f3f3f3;
}


/* dashboard - tables 
---------------------------------------------------- */

table.dashboard {
    width:100%;
    margin-bottom:50px;
}

table.dashboard td, table.dashboard th {
    padding:10px;
    border-bottom:1px solid #ddd;
    text-align: left;
    vertical-align: top;
}

table.dashboard th {
    font-weight:bold;
    padding:5px 10px;
    font-size:85%;
}

table.dashboard td.row-header {
    border:none;
}

table.dashboard a.button {
    color:#cc0000;
    font-weight:bold;
    border:1px solid #ddd;
}

table.dashboard img {
    width:100%;
}

/* Breadcrumbs 
---------------------------------------------------- */

ul.breadcrumb {
    padding-bottom: 10px;
    list-style: none;
    text-transform: uppercase;
    font-weight:normal;
    font-size:85%;
}

ul.breadcrumb li {
    display: inline;
    color:#999;
}

ul.breadcrumb li+li:before {
    padding: 10px;
    color: black;
    content: "\f0da";
    font-family: FontAwesome;
    color:#ccc;
}

ul.breadcrumb li a:hover {
    color: #01447e;
    text-decoration: underline;
}

.breadcrumb a {
    text-decoration: none;
}


/* Product Tree List 
---------------------------------------------------- */

ul.products { 
    list-style: none;
    width:100%;
}

ul.products li {
    margin: 8px 0;
}

ul.products li ul {
    margin-left:10px;
}

.filter-box {
    border-right:3px solid #fff;
    padding:0 15px;
    height:200px;
    overflow: scroll;
    background:#fff;
}

.info-box .filter-box {
    padding:0 0 10px 10px;
}

.filter-box::-webkit-scrollbar {
    -webkit-appearance: none;
}

.filter-box::-webkit-scrollbar:vertical {
    width: 10px;
}

.filter-box::-webkit-scrollbar:horizontal {
    height: 0;
}

.filter-box::-webkit-scrollbar-thumb {
    border-radius: 8px;
    border: 2px solid #f3f3f3; /* should match background, can't be transparent */
    background-color: rgba(0, 0, 0, .4);
}

.filter-box::-webkit-scrollbar-track { 
    background-color: #f3f3f3; 
    border-radius: 8px; 
}

/* Product Results 
---------------------------------------------------- */

ul.product-results li {
    width: 23%;
    padding:10px;
    text-align: left;
    border: 1px solid #ddd;
    border-bottom: 1px solid #ddd;
    display: -moz-inline-stack;
    display: inline-block;
    vertical-align: bottom;
    margin: 5px;
    zoom: 1;
    *display: inline;
}

ul.product-results li a {
    text-decoration:none;
    font-weight:bold;
}

ul.product-results li a i {
    margin-bottom:10px;
}

ul.product-results li h5 {
    font-size:85%;
    line-height: normal;
    margin-bottom:5px;
    color:#999;
}

ul.product-results li img {
    float:left;
    margin-right:10px;
}

/* Documents Table 
---------------------------------------------------- */

table.documents {
    border-collapse: collapse;
}

.documents td.heading {
    background:#ddd;
}

.documents h3, .documents h4 {
   margin:0; 
}

.documents th {
    background:#f3f3f3;
    font-weight:bold;
    padding:5px 10px;
    font-size:85%;
    text-align:left;
}

.documents td {
    padding:10px;
    vertical-align: top;
    border:none;
}

.documents img {
    width:100%;
}

.documents img.prod-search {
    width:20%;
    height:auto;
}

td.section-cat {
    font-weight:normal;
    padding-left:15px;
    color:#999;
    border-bottom: 1px solid rgba(31, 131, 173, 0.3);
}

table.small-padding td {
    padding:5px;
}



/* footer 
---------------------------------------------------- */

footer,
.push {
  height: 120px;
}

footer {
    background:#555;
    padding:20px;
    overflow: auto;
}

footer li {
    display:inline;
    margin:0 0 0 20px;
}

footer a, footer p {
    text-decoration: none;
    color:#ddd;
}

footer a.button {
    text-align:right;
}

footer i {
    color:#999;
    padding-right:10px;
}

/* Wizard Styles - see also css in assets/tabs/css
---------------------------------------------------- */

.button-bar {
    border-top: 1px solid #ddd;
    width:100%;
    margin:40px 0 0 0;
    padding:15px 0;
}


/* global styles 
---------------------------------------------------- */

.white-bg {
    background:#fff;
}

.gray-bg {
    background:#f3f3f3;
}

.circle {
    background-color:#cc0000;
    border:2px solid #fff;    
    height:15px;
    border-radius:50%;
    -moz-border-radius:50%;
    -webkit-border-radius:50%;
    width:15px;
    position:absolute;
    right:-5px;
    top:0;
}

input[type=text] {
    box-sizing: border-box;
    border: 1px solid #ccc;
    border-radius: 3px;
    background-color: white;
    padding: 10px 20px 10px 40px;
    outline: none;
}

input.search {
    background-image: url('../images/icon_search.png');
    background-position: 10px 10px; 
    background-repeat: no-repeat;
}

.input_container {
    position:relative;
    padding:0;
    margin:0;
}

.input {
    height:35px;
    margin:0;
    padding: 5px 5px 5px 30px;
}

.input_img {
    position:absolute;
    top:5px;
    right:20px;
    width:10px;
    height:10px;
    color:#cccccc;
}

fieldset {
    border:1px solid #ccc;
    border-radius: 3px;
    padding:10px;
}

legend {
    font-weight: bold;
}

.date {
    text-transform: uppercase;
    font-weight:bold;
}

.doc-type {
    color:#999;
    font-weight:normal;
    line-height: 1.5em;
    text-transform: uppercase;
    font-size: 85%;
}

.more {
    position:absolute;
    left:35px;
    bottom:35px;
}

.button {
    padding:10px 15px;
    border:1px solid #ddd;
    text-transform: uppercase;
    text-decoration: none;
    font-weight:bold;
    display:inline-block;
    color:#cc0000;
    border-radius:3px;
    font-size:95%;
}

.button-red {
    background:#cc0000;
    color:#fff;
    border: transparent;
}

.button-blue {
    background:#1f83ad;
    color:#fff;
    border: transparent;
}

.small-button {
    padding:5px 5px 3px 5px;
}

.search-clear {
    text-transform:uppercase;
    text-decoration:none;
    margin:10px 10px 0 0;
    padding:0;
}

.pagination {
    margin:20px 0 20px 0;
    bottom:0;
    position:absolute;
    display:block;
}

.pagination a {
    margin-right:10px;
}

.document {
    background:#eee;
    margin:0 0 10px 0;
    width:100%;
    min-height:120px;
    padding:10px;
    text-align: center;
    border-radius: 3px;
    border:1px solid #ccc;
}

.thumbnails {
    padding:0 10px;
}

ul.list {
    list-style: disc;
    margin-left:20px;
}

.generic-bg {
    background:#cc0000;
}

.scrollbar::-webkit-scrollbar {
    -webkit-appearance: none;
}

.scrollbar::-webkit-scrollbar:vertical {
    width: 10px;
}

.scrollbar::-webkit-scrollbar:horizontal {
    height: 0;
}

.scrollbar::-webkit-scrollbar-thumb {
    border-radius: 8px;
    border: 2px solid #f3f3f3; /* should match background, can't be transparent */
    background-color: rgba(0, 0, 0, .4);
}

.scrollbar::-webkit-scrollbar-track { 
    background-color: #f3f3f3; 
    border-radius: 8px; 
}

/* Where to Buy - dealer results and header
---------------------------------------------------- */

header.wtb {
    background: #a00;
    height:60px;
}

header.wtb .logo {
    background:#cc0000; 
    width:150px; 
    border-right: 1px solid #f03838; 
    height:60px;
    padding:12px 20px;
}

.dealer-results-list {
    border-left:1px solid #ddd; 
    border-top:1px solid #ddd;  
    border-bottom:1px solid #ddd; 
    max-height:650px; 
    overflow:scroll; 
    background:#fff;
}

.dealer-results-list h1 {
    font-size:100%;
    background:#ddd;
    margin:0;
    padding:5px 10px;
    font-weight:bold;
    color:#888;
}

.dealer-results-header {
    background: #f3f3f3;
    padding:10px;
    text-align:center;
    border-right:1px solid #ddd;
}

.dealer-results-header ul {
    margin:10px 0;
    padding:0;
}

.dealer-results-header li {
    display: inline;
    margin:0;
    padding:0;
}

.dealer-results-header a {
    color:#fff;
    text-decoration: none;
    background:#1f83ad;
    margin:0;
    padding:5px 10px;
}

.dealer-results-header a.active {
    background:#0c5b7c; 
}

.dealer-results {
    border-bottom:1px solid #ddd;
    border-right:1px solid #ddd;
    padding:10px;
}

.dealer-results a {
    text-decoration: none;
}

.dealer-results:hover {
    background:#f3f3f3;
}

.dealer-results h4,
.dealer-results h5,
.dealer-results p {
    padding:0;
    margin:0;
}

.dealer-results h2 {
    margin:0;
    padding:0;
}

.dealer-results h4 {
    font-size:115%;
}

.dealer-results h5 {
    text-transform: uppercase;
    color:#eeb214;
}

.fa-pull-left {
    width:50px;
    font-family: sans-serif;
}

.dealer-info {
    margin-left:40px;
}

.dealer-selected {
    background: #1f83ad;
    color:#fff;
}

.dealer-selected p {
    color:#fff;
}

.dealer-selected .fa-pull-left .fa-circle {
    color:#0c5b7c;  
}

.dealer-selected-results {
    background: #fff;
    width:300px;
    position:absolute;
    top:150px;
    left:50px;
    box-shadow: -4px -4px 2px -2px rgba(0,0,0,0.25);
    z-index: 1000;
}

.dealer-selected-results:after {
	bottom: 100%;
	left: 18.5%;
	border: solid transparent;
	content: " ";
	height: 0;
	width: 0;
	position: absolute;
	pointer-events: none;
	border-color: rgba(255, 255, 255, 0);
	border-bottom-color: #ffffff;
	border-width: 10px;
	margin-left: -10px;
    
}

.dealer-selected-results h3,
.dealer-selected-results p {
    margin-bottom:7px;
}

.dealer-icons i {
    color:#aaa;
    margin:5px;
}

.dealer-loc {
    background: url(../images/icon_map.png) no-repeat;
    width:40px;
    height:40px;
    text-align: center;
    padding-top:8px;
    color:#fff;
}

a.dealer-loc {
    color:#fff;
    text-decoration: none;
    font-weight:bold;
}

.wtb-tag {
    border:1px solid #ddd;
    border-radius:3px;
    font-size:85%;
    padding:5px 8px;
    margin:0 10px 5px 0;
    display:inline-block;
}

.wtb-tag:after {
    content: "\f00d"; 
    font-family: FontAwesome;
    padding-left:5px;
    color:#bbb;
}


/* Tooltips
---------------------------------------------------- */

.tooltip {
    position: relative;
    display: inline-block;
    text-decoration: none;
}

.tooltip .tooltiptext {
    visibility: hidden;
    width: 240px;
    background-color: #555;
    color: #fff;
    border-radius: 3px;
    padding: 10px;
    position: absolute;
    z-index: 1;
    top: 150%;
    left: 50%;
    margin-left: -60px;
    font-weight:normal;
    font-family: sans-serif;
}

.tooltip .tooltiptext::after {
    content: "";
    position: absolute;
    bottom: 100%;
    left: 25%;
    margin-left: -5px;
    border-width: 5px;
    border-style: solid;
    border-color: transparent transparent #555 transparent;
}

.tooltip:hover .tooltiptext {
    visibility: visible;
}



/* forms 
---------------------------------------------------- */
textarea, input[type="text"], input[type="button"], input[type="tel"], input[type="password"], input[type="email"], input[type="search"] {
	width: 100%;
	color: #4a4a4a;
	border: 1px solid #ccc;
	background-color: #fff;
	padding: 8px;
	border-radius: 3px;
    font-size:1em;
}

input[type="button"]  {
	width:auto;
	margin:10px 0;
    padding:5px 15px;
}

label {
  font-weight: bold;
  color: #4444444;
  display: -moz-inline-stack;
  display: inline-block;
  zoom: 1;
  _overflow: hidden;
  margin: 10px 0 3px 0;
}

textarea.error, select[multiple].error, input[type="text"].error, input[type="tel"].error, input[type="password"].error, input[type="email"].error, input[type="search"].error, .select select.error, select.error {
  border: 1px solid #cc0000;
  color: #cc0000;
  -webkit-box-shadow: 0 0 5px 0 rgba(255,178,157,0.75);
  -moz-box-shadow: 0 0 5px 0 rgba(255,178,157,0.75);
  -o-box-shadow: 0 0 5px 0 rgba(255,178,157,0.75);
  box-shadow: 0 0 5px 0 rgba(255,178,157,0.75);
}

.error-box {
	position: relative;
	background: #cc0000;
    color:#fff;
    padding:10px;
    border-radius:3px;
    margin-top:10px;
    font-size:85%;
}
.error-box:after {
	bottom: 100%;
	left: 50%;
	border: solid transparent;
	content: " ";
	height: 0;
	width: 0;
	position: absolute;
	pointer-events: none;
	border-color: rgba(204, 0, 0, 0);
	border-bottom-color: #cc0000;
	border-width: 5px;
	margin-left: -5px;
}

select {
    border: 1px solid #ddd;
    border-radius:3px;
    width: 100%;
    padding: 8px;
    border: 1px solid #ccc;
    font-size:1em;
    -webkit-appearance: none;
    -moz-appearance: none;
    appearance: none;
    background: #fff url(../images/icon_select_down.png) 99% / 15% no-repeat;
    background-size:25px 25px;
    outline: none;
}

select::-ms-expand { 
    display: none; /* remove default arrow in IE 10 and 11 */
}

/* target Internet Explorer 9 to undo the custom arrow */
@media screen and (min-width:0\0) {
    select {
        background:none\9;
        padding: 5px\9;
    }
}

.notes {
    font-weight:normal;
    font-size: 90%;
    font-style: italic;
}

::-webkit-input-placeholder {
    color: #999;
    font-style: italic;
    font-size:.875em;
}

.req-field {
    border-left:4px solid #cc0000 !important;
}

.form {
    width:100%;
}

.form .col {
    padding:10px 5px;
}

@media (max-width: 600px) {
    .form .col {
        padding:0 0 5px 0;
    }
}

.show-select { 
    /*makes the div show when option in select box is chosen. 
    http://www.tutorialrepublic.com/codelab.php?topic=faq&file=jquery-show-hide-div-using-select-box */
    display: none;
}

.video-container {
position: relative;
padding-bottom: 56.25%;
padding-top: 30px; height: 0; overflow: hidden;
}
 
.video-container iframe,
.video-container object,
.video-container embed {
position: absolute;
top: 0;
left: 0;
width: 100%;
height: 100%;
}


/* CSS Boilerplate 
---------------------------------------------------- */

.left {
    float:left;
}

.right {
    float:right;
}

.center {
    text-align:center;
}

.clear {
    clear: both;
}

.hidden {
    display: none;
}

.text-left {
    text-align:left;
}

.text-right {
    text-align:right;
}

.font-110 {
    font-size:110%;
}

.font-85 {
    font-size:85%;
}

.font-75 {
    font-size:75%;
}

.white-text {
    color:#fff;
}

.pad-left {
    margin-left:20px;
}

.pad-right {
    margin-right:20px;
}

.pad-top {
    margin-top:20px;
}

.pad-bottom {
    margin-bottom:20px;
}

.pad-inside {
    padding:20px;
}

.pad-15 {
    padding:15px;
}

.pad-20 {
    padding:20px;
}

.pad-top-10 {
    padding-top:10px;
}

.no-pad {
    padding:0 !important;
}

.no-margin {
    margin:0;
}

.width-100 {
    width:100%;
}

.width-90 {
    width:90%;
}

.width-80 {
    width:80%;
}

.width-70 {
    width:70%;
}

.width-60 {
    width:60%;
}

.width-50 {
    width:50%;
}

.width-48 {
    width:48%;
}

.width-45 {
    width:45%;
}

.width-40 {
    width:40%;
}

.width-30 {
    width:30%;
}

.width-25 {
    width:25%;
}

.width-20 {
    width:20%;
}

.width-15 {
    width:15%;
}

.width-10 {
    width:10%;
}

.width-5 {
    width:5%;
}

.bg-50 {
    background:rgba(0,0,0,.5);
}

.bg-40 {
    background:rgba(0,0,0,.4);
}

.bg-30 {
    background:rgba(0,0,0,.3);
}

.bg-20 {
    background:rgba(0,0,0,.2);
}

.bg-15 {
    background:rgba(0,0,0,.15);
}

.bg-10 {
    background:rgba(0,0,0,.1);
}

.bg-5 {
    background:rgba(0,0,0,.05);
}

.relative {
    position: relative;
}

.curve {
border-radius: 3px;
}

.border {
    border:1px solid #ddd;
}


ul.nav-bar li {
    display:block !important;
}

.comments {
    color:magenta;
    font-size:85%;
    font-style: italic;
}

.not-bold {
    font-weight:normal;
}