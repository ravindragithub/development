@charset "UTF-8";
/* CSS Document */

@font-face{font-family:DINPro-Regular;src:url(//d3jq3t74hzt5uu.cloudfront.net/assets/DINPro-Regular/DINPro-Regular-f29fffa62ce017a5321c23526a5f70ff.eot);src:url(//d3jq3t74hzt5uu.cloudfront.net/assets/DINPro-Regular/DINPro-Regular-b1a36c1a0d09f442bc9b0e2af0821922.woff) format("woff"),url(//d3jq3t74hzt5uu.cloudfront.net/assets/DINPro-Regular/DINPro-Regular-1fa6e10834fadad219d07112581465b2.ttf) format("truetype"),url(//d3jq3t74hzt5uu.cloudfront.net/assets/DINPro-Regular/DINPro-Regular-42aa18cb3c562b487865571506211c74.svg) format("svg");font-weight:normal;font-style:normal}

@font-face{font-family:DINPro-Light;src:url(//d3jq3t74hzt5uu.cloudfront.net/assets/DINPro-Light/DINPro-Light-631fa9fb734522abe6292d2495ee3e90.eot);src:url(//d3jq3t74hzt5uu.cloudfront.net/assets/DINPro-Light/DINPro-Light-4c12a07b8a62dfe706a7c1603e632feb.woff) format("woff"),url(//d3jq3t74hzt5uu.cloudfront.net/assets/DINPro-Light/DINPro-Light-ec7487580b45c488b38a7b483912ec9c.ttf) format("truetype"),url(//d3jq3t74hzt5uu.cloudfront.net/assets/DINPro-Light/DINPro-Light-e78a417e505b4d447a3337e831a61c91.svg) format("svg");font-weight:normal;font-style:normal}

@font-face{font-family:DINPro-Black;src:url(//d3jq3t74hzt5uu.cloudfront.net/assets/DINPro-Black/DINPro-Black-69b7a2ba459c5677c6263d10af1c3c1d.eot);src:url(//d3jq3t74hzt5uu.cloudfront.net/assets/DINPro-Black/DINPro-Black-699671d053530964af2513569c3819a9.woff) format("woff"),url(//d3jq3t74hzt5uu.cloudfront.net/assets/DINPro-Black/DINPro-Black-95ae033df152d52b8c52518f56de7e7c.ttf) format("truetype"),url(//d3jq3t74hzt5uu.cloudfront.net/assets/DINPro-Black/DINPro-Black-e51baa79699db6fc2790a37240e06e8e.svg) format("svg");font-weight:normal;font-style:normal}

@font-face{font-family:DINPro-Medium;src:url(//d3jq3t74hzt5uu.cloudfront.net/assets/DINPro-Medium/DINPro-Medium-7065e42c7414c2865e3c32eb511e05e1.eot);src:url(//d3jq3t74hzt5uu.cloudfront.net/assets/DINPro-Medium/DINPro-Medium-0d0ab09dfd00d95cce52be3d7deecb6e.woff) format("woff"),url(//d3jq3t74hzt5uu.cloudfront.net/assets/DINPro-Medium/DINPro-Medium-3532654c7717ecc15f2dffa012a763ce.ttf) format("truetype"),url(//d3jq3t74hzt5uu.cloudfront.net/assets/DINPro-Medium/DINPro-Medium-ea40e0fe982af4043d26d881cc36daae.svg) format("svg");font-weight:normal;font-style:normal}

@font-face{font-family:DINPro-Bold;src:url(//d3jq3t74hzt5uu.cloudfront.net/assets/DINPro-Bold/DINPro-Bold-05675ad23dba9a7690ea3e5bf199c549.eot);src:url(//d3jq3t74hzt5uu.cloudfront.net/assets/DINPro-Bold/DINPro-Bold-16829cfd61989d7977f772a4563139cc.woff) format("woff"),url(//d3jq3t74hzt5uu.cloudfront.net/assets/DINPro-Bold/DINPro-Bold-4e05b39f59a99caccafd50272b7b8fc7.ttf) format("truetype"),url(//d3jq3t74hzt5uu.cloudfront.net/assets/DINPro-Bold/DINPro-Bold-cae4e441c543f18b599d087a26ea89aa.svg) format("svg");font-style:normal}

body {
	font-size:100%;
  	font-family: DINPro-Regular,Arial;
  	color: #292c2f;
  	line-height: 1.5em;
	background-color:#f3f3f3;
}

.bodyDiv{
    font-size: 1.1em;
}

h1, h2, h3, p {
    /*padding-bottom:15px;*/
    line-height: normal;
}

h1 {
    font-size:2em;
}

h2 {
	font-size:1.5em;
	color:#455b75;
}

h2.product-heading {
    font-size:2.25em;
    text-align:center;
    color:#000;
    padding:10px;
    background-color: #eef5ff;
    line-height:1em;
    -moz-border-radius: 3px;
    border-radius: 3px;
}

h3 {
	font-size:1.15em;
    color:#7c7c7c;
	font-weight:bold;
}

h4 {
	font-size:1em;
	font-weight:bold;
    color:#30445b;
}

hr {
    border: 0;
    height: 1px;
    border-bottom:2px solid #c7c7c7;
	margin-bottom:30px;
}

a {
    color: #5282bd;
}

.wrapper {
    margin:0 auto;
	width:100%;
	max-width:1200px;
	padding:20px;
	float:left;
}

#top {
    background-color:#000;
    padding:3px 20px 3px 3px;
    text-align:right;
    margin:0 auto;
	width:100%;
    color:#fff;
}

#top a {
    color:#fff;
    font-size:.875em;
    padding:0 10px;
    text-transform: uppercase;
    font-weight:bold;
}

#top a:hover {
    color:#9bb1cb;
}

#header {
    background: #30445b url(../images/header_bg.png) no-repeat top left;
    height:60px;
    padding:10px 0 0 20px;
    border-bottom: 1px solid #292c2f;
}

#header h1 {
    color:#fff;
    display:inline;
    padding:10px 20px 0 0;
    float:right;
}

#sidebar {
    width:200px;
    background-color:#444444;
    position: absolute;
    height: 100%;
}

#sidebar li {
    padding:20px;
    text-transform: uppercase;
    color:#fff;
    -webkit-text-shadow: 1px 1px 0 #000;
    -moz-text-shadow: 1px 1px 0 #000;
    text-shadow: 1px 1px 0 #000;
    font-weight:bold;
}

#sidebar li.active {
    background: #232323 url(../images/arrow.png) no-repeat center right;
}

#sidebar li.dim {
	color:#888;
}

#sidebar a {
	color:#fff;
    text-decoration: none;
}

#sidebar hr {
    border-bottom:2px solid #7c7c7c;
    margin:0 20px 25px 20px;
}

#main {
    float:left;
    width:100%;
    padding-left:210px;
}

#main p {
	padding-bottom:10px;
}

#horizontalTab h1 {
    font-size:1.75em;
    color:#30445b;
}

.panel {
    margin-bottom: 5px;
	background-color:#fff;
	-webkit-border-bottom-right-radius: 3px;
	-webkit-border-bottom-left-radius: 3px;
	-moz-border-radius-bottomright: 3px;
	-moz-border-radius-bottomleft: 3px;
	border-bottom-right-radius: 3px;
	border-bottom-left-radius: 3px;
	-webkit-box-shadow: 1px 1px 2px 0px rgba(204, 204, 204, 1);
	-moz-box-shadow:    1px 1px 2px 0px rgba(204, 204, 204, 1);
	box-shadow:         1px 1px 2px 0px rgba(204, 204, 204, 1);
    overflow: auto;
	padding:30px;
}

.box {
    background-color:#fff;
    border:1px solid #c7c7c7;
	-moz-border-radius: 3px;
	border-radius: 3px;
    padding:0;
    overflow:auto;
    margin-bottom:30px;
}

.box-hd {
    background-color:#f4f4f4;
    padding:10px;
}

.box-content {
    padding:10px;
	width: 480px;
	margin: auto;
	padding-bottom:0;
}

.box-content p {
    margin-bottom:10px;
}

.output-box {
    border-left:5px solid #c7c7c7;
    padding:20px;
    background:#f4f4f4;
    -moz-border-radius: 3px;
	border-radius: 3px;
    overflow: auto;
}

.output-box td {
    padding:3px;
    font-size:.9375em;
}

.active-box {
    background-color: #d6e7ff;
}

.button-bar {
    border-top:2px solid #c7c7c7;
    margin-top:20px;
}

.two-col {
    width:48%;
}

.three-col {
    width:31%;
}

.button, input[type="button"], input[type="submit"] {
    color: #fff;
    padding: 6px 19px 7px;
    border: 1px solid #4981bf;
    cursor: pointer;
    text-align: center;
    text-decoration: none;
    font-weight:bold;
    -webkit-box-sizing: border-box;
    -moz-box-sizing: border-box;
    box-sizing: border-box;
    display: -moz-inline-stack;
    display: inline-block;
    zoom: 1;
    _overflow: hidden;
    -webkit-border-radius: 3px;
    -moz-border-radius: 3px;
    border-radius: 3px;
    -webkit-box-shadow: inset 1px 1px 0 rgba(255,255,255,0.32);
    -moz-box-shadow: inset 1px 1px 0 rgba(255,255,255,0.32);
    -o-box-shadow: inset 1px 1px 0 rgba(255,255,255,0.32);
    box-shadow: inset 1px 1px 0 rgba(255,255,255,0.32);
    background: #4A81C0 none repeat-x scroll 0% 0%;
    margin:20px 0;
}
input[type="submit"]:disabled, input[type="button"]:disabled {
    cursor: auto;
    background: #C1C1C1;
}

a.button:hover {
    background-image: -webkit-gradient(linear, left top, left bottom, color-stop(0%, #4a81c0), color-stop(100%, #79aeec));
    background-image: -webkit-linear-gradient(top, #4a81c0, #79aeec);
}

.small-button {
    margin:0;
    padding:3px 10px;
}

.sidebar-button {
    display:block;
    margin:0 20px
}

.left {
    float:left;
}

.right {
    float:right;
}

.clear {
    clear: both;
}

.center {
    text-align:center;
}

.exit {
    clear:both;
    margin-bottom:20px;
}

.notes {
	font-style:italic;
	font-size:.875em;
	font-weight:normal;
}

.inline-note {
	display:inline;
	padding-right:10px;
}

.req {
    color:#FF542F;
}

.required {
    float:right;
    font-size:.875em;
}

.not-bold {
	font-weight:normal;
}

small {
	font-size:70%;
}

.comment {
    color:#b835f1;
    font-size:.875em;
    font-style: italic;
}

.green {
    color:#43ab0c;
}

.red {
    color:#ff542f;
}

.pad-left {
    margin-left:20px;
}

/* styles for autocomplete ----------------------*/
.ui-autocomplete {
    position: absolute;
    top: 100%;
    left: 0;
    z-index: 1000;
    float: left;
    display: none;
    min-width: 160px;
    padding: 4px 0;
    margin: 0 0 10px 25px;
    list-style: none;
    background-color: #ffffff;
    border:1px solid #ccc;
    -webkit-border-radius: 3px;
    -moz-border-radius: 3px;
    border-radius: 3px;
    -webkit-box-shadow: 0 5px 10px rgba(0, 0, 0, 0.2);
    -moz-box-shadow: 0 5px 10px rgba(0, 0, 0, 0.2);
    box-shadow: 0 5px 10px rgba(0, 0, 0, 0.2);
    -webkit-background-clip: padding-box;
    -moz-background-clip: padding;
    background-clip: padding-box;
    *border-right-width: 2px;
    *border-bottom-width: 2px;
}

.ui-menu-item:hover {
	background:#f3f3f3;
	border-left:1px solid #ccc;
	border-right:1px solid #ccc;
}


/* styles to force scrollbar to show in iframe on mac - used on review ------------- */
.frame::-webkit-scrollbar {
    -webkit-appearance: none;
}

.frame::-webkit-scrollbar:vertical {
    width: 11px;
}

.frame::-webkit-scrollbar:horizontal {
    height: 11px;
}

.frame::-webkit-scrollbar-thumb {
    border-radius: 8px;
    border: 2px solid #f3f3f3; /* should match background, can't be transparent */
    background-color: rgba(0, 0, 0, .5);
}

.frame::-webkit-scrollbar-track {
    background-color: #f3f3f3;
    border-radius: 8px;
}

select[multiple], input[type="text"],  input[type="tel"], input[type="password"], input[type="email"], input[type="search"], .select select {
	width: 50%;
	color: #4a4a4a;
	border: 1px solid #c7c7c7;
	background-color: #fff;
	padding: 4px 5px 5px;
	-webkit-box-sizing: border-box;
	-moz-box-sizing: border-box;
	box-sizing: border-box;
	-webkit-border-radius: 3px;
	-moz-border-radius: 3px;
	border-radius: 3px;
}

input[type="button"] , input[type="submit"]{
	width:auto;
	margin:10px;
}

input[type="radio"]:checked + span { 
    font-weight: bold; 
}

textarea {
    width:100%;
}


label {
  text-align: right;
  width: 49%;
  padding-right: 1%;
  font-weight: bold;
  color: #4a4a4a;
  display: -moz-inline-stack;
  display: inline-block;
  zoom: 1;
  _overflow: hidden;
  margin-bottom: 3px;
}

textarea.error, select[multiple].error, input[type="text"].error, input[type="tel"].error, input[type="password"].error, input[type="email"].error, input[type="search"].error, .select select.error {
  border: 1px solid #fe6d55;
  color: #fe6d55;
  -webkit-box-shadow: 0 0 5px 0 rgba(255,178,157,0.75);
  -moz-box-shadow: 0 0 5px 0 rgba(255,178,157,0.75);
  -o-box-shadow: 0 0 5px 0 rgba(255,178,157,0.75);
  box-shadow: 0 0 5px 0 rgba(255,178,157,0.75);
}

select {
    width:50%;
}

table.form-table {
	width:100%;
    margin-top:10px;
}

.form-table td {
	padding:0 5px 25px 0;
	vertical-align:top;
}

table.inside {
	width:95%;
	border:1px solid #c7c7c7;
	-moz-border-radius: 3px;
	border-radius: 3px;
	border-collapse:separate;
}

table.inside th {
	background-color:#f4f4f4;
	text-align:left;
	padding:10px;
}

.empty-column-content { /*supports extended role column headers*/
		display: none;
}

.inside td {
	padding:10px;
}

.inside ul li {
      margin-left: 20px;
      text-indent: -20px;
	  padding-bottom:10px;
}

.inside label {
	display:inline;
}

ul, li {
	margin: 0; padding:0;
}

ul.bullets {
    margin:5px 0 0 10px;
}

.bullets li {
    list-style: disc;
    padding-bottom:2px !important;
    padding-left:20px;
}

/* tables... derived from jquery tablesorter CSS*/
	table.myKVHtablesorter {
		/*font-family:arial;*/
		/*background-color: #CDCDCD;*/
		/*margin:10px 0pt 15px;*/
		/*font-size: 8pt;*/
		/*width: 100%;*/
		text-align: left;
	}
	table.myKVHtablesorter thead tr th, table.myKVHtablesorter tfoot tr th {
		/*background-color: #e6EEEE;*/
		/*border: 1px solid #FFF;*/
		/*font-size: 8pt;*/
		/*padding: 4px;*/
	}
	table.myKVHtablesorter thead tr .header {
		padding-left: 20px;
		background-repeat: no-repeat;
		background-position: center left;
		cursor: pointer;
	}
	table.myKVHtablesorter tbody td {
		/*color: #3D3D3D;*/
		/*padding: 4px;*/
		/*background-color: #FFF;*/
		vertical-align: center;
	}
	table.myKVHtablesorter tbody tr.odd td {
		/*background-color:#F0F0F6;*/
	}
	table.myKVHtablesorter thead tr .headerSortDown, table.myKVHtablesorter thead tr .headerSortUp {
		background-color: #80A8D5;
	}

/* plan tables styles -------------------*/

.plan-type td {
	padding:5px;
    border-bottom:1px solid #ccc;
}

.desc-row {
	background-color:#f3f3f3;
	font-weight:bold;
}

.plan-desc {
    font-size:90%;
}

/* tooltip styles */

.hasTooltip {
    padding:0 0 5px 0;
    margin:0;
}

.hasTooltip + span {
    display:none;
}

.showTooltip {
    background-color: black;
    color: white;
    padding:10px;
    margin-left: 28px;
    position: absolute;
    max-width: 250px;
    -moz-border-radius: 5px;
    -webkit-border-radius: 5px;
    border-radius: 5px;
}

.showTooltip:after {
	right: 100%;
	top: 12px;
	border: solid transparent;
	content: " ";
	height: 0;
	width: 0;
	position: absolute;
	pointer-events: none;
	border-right-color: #000;
	border-width: 5px;
	margin-top: -5px;
}

/* ----- Image grids ----- */

ul.rig {
	list-style: none;
	font-size: 0px;
	margin-left: -2.5%; /* should match li left margin */
}

ul.rig li {
	display: inline-block;
	margin: 0 0 2.5% 2.5%;
	background: #fff;
	border: 1px solid #ddd;
	font-size: 16px;
	font-size: 1rem;
	vertical-align: top;
	border:1px solid #c7c7c7;
	-moz-border-radius: 3px;
	border-radius: 3px;
}

ul.rig li:hover {
    box-shadow: 0 0 10px #9bb1cb;
}

ul.rig li.selected {
    box-shadow: 0 0 7px #3ead00;
}

ul.rig li.selected input {
    background-color: #3ead00;
    font-weight: bold;
    color:#fff;
}

ul.rig li h3 {
	margin: 0;
	background-color:#f4f4f4;
	padding:10px;
}

ul.rig li h4 {
    padding:0 0 5px 0;
    font-size:.75em;
    color:#999;
    font-weight:500;
    border-bottom: 1px dotted #ccc;
    margin-bottom:5px;
}

ul.rig li p {
    padding:10px;
	text-align:center;
}

ul.rig li img {
    max-width:130px;
}


ul.rig.columns li {
	width: 22.5%; /* this value + 2.5 should = 25%  for a 4 column layout */
}



/* MEDIA QUERIES ------------------------------- */

@media (max-width: 900px) {
    ul.rig li {
        width: 47.5% !important;
        transition: all .5s ease;
        -webkit-transition:  all .5s ease;
    }
}

@media (max-width: 600px) {
	ul.grid-nav li {
		display: block;
		margin: 0 0 5px;
	}
	ul.grid-nav li a {
		display: block;
	}
	ul.rig {
		margin-left: 0;
	}
	ul.rig li {
		width: 100% !important; /* over-ride all li styles */
		margin: 0 0 20px;
	}
}
