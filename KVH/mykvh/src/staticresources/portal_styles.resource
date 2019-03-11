@charset "UTF-8";
/* CSS Document */

*{	box-sizing:border-box;
	-moz-box-sizing:border-box;
}

img {
	border:none;	
}

.page-content {
	font-family:Arial, Helvetica, sans-serif;
	font-size:14px;
    line-height:18px;
	padding:20px;
    max-width:1000px;
    margin:auto;
    background-color:#fff;
}

.page-content h1,
.page-content h2,
.page-content h3,
.page-content h4,
.page-content h5,
.page-content p,
.page-content table {
    font-family:Arial, Helvetica, sans-serif;
    display:block;
    margin-bottom:15px;
}

.page-content h1 {
    font-size: 24px;
    line-height:28px;
    color: #2F435B;
}

.page-content h2 {
    font-size:18px;
    line-height:24px;
    font-weight:bold;
	color:#777;
}

.page-content h3 {
    font-size: 16px;
    line-height:20px;
	font-weight:bold;
	color:#2F435B;
	margin:0;
}

.page-content h4 {
	font-size: 16px;
    font-weight:normal;
    line-height:20px;
    color:#2F435B;
	margin:0;
}

.page-content h5 {
    font-size: 18px;
    line-height:22px;
	color:#436082;
	margin-top:-8px;
	margin-bottom:18px;
}

.page-content p,
.page-content table {
	color:#292C2F;
    width:100%;
}

.page-content td {
	padding-left:10px;
}

.page-content .header-row {
	padding:15px;
    -moz-border-radius: 3px;
    border-radius:3px;
    background: #eeeeee;
    font-size: 16px;
    line-height:20px;
	font-weight:bold;
	color:#2F435B;
}

.page-content ol {
    margin-bottom:20px;
}

.page-content ol,
.page-content ul {
	margin:0 0 20px 0;
}

.page-content ol li,
.page-content ul li {
    padding:5px 0;
}

.page-content input[type=submit] {
    display:inline-block;
	color:#fff;
	font-family:Arial, Helvetica, sans-serif;
	text-align:center;
	font-size:14px;
    background: #2C405C;
    filter: progid:DXImageTransform.Microsoft.gradient(startColorstr='#4f7096', endColorstr='#2C405C');
    background: -webkit-gradient(linear, left top, left bottom, from(#4f7096), to(#2C405C));
    background: -moz-linear-gradient(top,  #4f7096, #2C405C); 
	cursor:pointer;
    padding:5px 10px;
    border:0;
    -moz-border-radius: 3px;
    border-radius: 3px;
}

.page-content input[type=submit]:hover {
 background:#2C405C;
}

.button-bar {
    width:100%;
    border-top:1px solid #ccc;
    padding:10px 0;
    margin:40x 0;
}

.support-home {
    float:right;
    text-transform: uppercase;
    font-size:10px;
    line-height:12px;
    font-weight:bold;
    text-align: center;
    background-color:#eee;
    -moz-border-radius: 20px;
    border-radius: 20px;
    padding:5px 20px;
}

.support-home a {
    text-decoration: none;
}

.space {
    padding:10px 0;
}

.space h3 {
	background:#eee;
	-moz-border-radius: 3px;
    border-radius: 3px;
	vertical-align:middle;
	padding:10px;
	margin-bottom:5px;
}
	

/* contact styles ---------------------------------------- */

.contact-content {
	width:800px;
	font-family:Arial, Helvetica, sans-serif;
	font-size:12px;
	line-height:1.2em;
	margin-left:8px;

}

.contact-content h1 {
    font-size: 22px;
	font-family:Arial, Helvetica, sans-serif;
    color: #2F435B;
}

.contact-content h2 {
    font-size: 16px;
	font-family:Arial, Helvetica, sans-serif;
	color:#fff;
	font-weight:normal;
	letter-spacing:1px;
	background:#2F435B;
	margin:0;
	padding:10px;
	border-top:3px #80A8D5 solid;	
}

.contact-content a{
	color:#80A8D5;
}

.contact-content table {
	vertical-align:top;
	width:100%;
	font-size:12px;
}

.contact-content td{
	border-bottom:1px #ccc solid;
	padding:10px;
	vertical-align:top;
	font-size:12px;
}

.contact-content tr.header-row{
	font-weight:bold;
	background:#eee;
	border-top:3px #80A8D5 solid;	
}

.contact-content tr.header-row td{
}

.contact-content ul{
	margin:0px;
	padding-left:20px;
}

.contact-content ul li{
	margin-bottom:8px;
}


.phone{
	font-size:14px;
	font-weight:bold;
	color:#2F435B;
}

.contact-content td.office{
	width:75px;
	font-size:12px;

}

.contact-content td.region{
	width:100px;
	font-size:12px;

}

.contact-content td.number{
	width:150px;
		font-size:12px;

}

.contact-content td.hours{
	width:160px;
		font-size:12px;

}

.contact-content td.services{
	width:160px;
		font-size:12px;

}

/*Home Styles */

.home h3 {
    font-size: 20px;
	font-family:Arial, Helvetica, sans-serif;
	color:#2F435B;
	margin:0;
	padding:10px;
	font-weight:normal;
}

.home a h4 {
	color:#2F435B;
	text-decoration:none;
    padding:5px  0 0 40px;
}

.home a {
	text-decoration:none;
}

.home-arrow {
    padding-right:10px; 
    vertical-align:middle;
}

.block {
    margin:20px 0;
    overflow: auto;
    padding:15px 15px 15px 15px;
    -moz-border-radius: 3px;
    border-radius:3px;
    background-color: #eeeeee;
}

.block:hover {
    background-color:#dbe6f2;
}

.block a {
	text-decoration:none;
}

.block p {
	padding: 0 0 0 40px;
	margin:5px 0;
}
	

.btn {
	display:inline-block;
	color:#fff;
	font-family:Arial, Helvetica, sans-serif;
	text-align:center;
	font-size:14px;
	text-decoration:none;
    background: #2C405C;
    filter: progid:DXImageTransform.Microsoft.gradient(startColorstr='#4f7096', endColorstr='#2C405C');
    background: -webkit-gradient(linear, left top, left bottom, from(#4f7096), to(#2C405C));
    background: -moz-linear-gradient(top,  #4f7096, #2C405C); 
	cursor:pointer;
    padding:5px 10px;
    -moz-border-radius: 3px;
    border-radius: 3px;
}

.btn:hover {
    background:#2C405C;
}

.right {
    float:right;
}

.left {
    float:left;
}

/* DEPRECATED ----------------------------- */

a.started {
	display:block;
	width:154px;
	padding:9px 10px;
	background:url(/resource/1380218764000/startedbtn) right center no-repeat #2E425C;
	border-radius:6px;
	margin-top:-3px;
	color:#fff;
	text-decoration:none;
	letter-spacing:1px;	
}

.section {
	width:100%;
	padding:20px 0px;
	margin-bottom:20px;
	border:solid 1px #2C405C;
	border-bottom-right-radius: 9px;
	border-bottom-left-radius: 9px;
}

