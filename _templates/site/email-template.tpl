<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<meta name="viewport" content="width=device-width" />
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
	<title>Рассылка</title>
<style type="text/css">{literal}
	* {
		margin: 0;
		padding: 0;
		font-family: "Helvetica Neue", "Helvetica", Helvetica, Arial, sans-serif;
		font-size: 100%;
		line-height: 1.6;
	}

	body {
		-webkit-font-smoothing: antialiased;
		-webkit-text-size-adjust: none;
		width: 100% !important;
		height: 100%;
	}

	img { max-width: 100%; }

	a { color: #348eda; }

	.btn-primary {
		text-decoration: none;
		color: #FFF;
		background-color: #348eda;
		border: solid #348eda;
		border-width: 5px 7px;
		line-height: 2;
		font-weight: bold;
		margin-right: 10px;
		text-align: center;
		cursor: pointer;
		display: inline-block;
		border-radius: 10px;
	}

	.btn-secondary {
		text-decoration: none;
		color: #FFF;
		background-color: #aaa;
		border: solid #aaa;
		border-width: 5px 7px;
		line-height: 2;
		font-weight: bold;
		margin-right: 10px;
		text-align: center;
		cursor: pointer;
		display: inline-block;
		border-radius: 10px;
	}

	.first {margin-top: 0;}
	.last {margin-bottom: 0;}
	.padding {padding: 10px 0;}

	table.body-wrap {width: 100%;padding: 20px;}
	table.body-wrap .container {border: 1px solid #f0f0f0;}
	table.footer-wrap {width: 100%;clear: both !important;}
	.footer-wrap .container p {font-size: 12px;color: #666;}
	table.footer-wrap a {color: #999;}

	h1, h2, h3 {font-family: "Helvetica Neue", Helvetica, Arial, "Lucida Grande", sans-serif;color: #000;margin: 40px 0 10px;line-height: 1.2;font-weight: 200;}
	h1 {font-size: 36px;}
	h2 {font-size: 28px;}
	h3 {font-size: 22px;}

	p, ul, ol {margin-bottom: 10px;font-weight: normal;font-size: 14px;}
	ul li, ol li {margin-left: 5px;list-style-position: inside;}
	.container {display: block !important;max-width: 600px !important;margin: 0 auto !important; clear: both !important;}
	.body-wrap .container {	padding: 20px;}
	.content {max-width: 600px;margin: 0 auto;display: block;	}
	.content table {width: 100%;}
	{/literal}</style>
</head>

<body bgcolor="#ffffff">

<table class="body-wrap">
	<tr>
		<td></td>
		<td class="container" bgcolor="#FFFFFF">
			<div class="content">
				<table>
					<tr>
						<td>
							<p>{include file="$emailTemplate"}</p>
						</td>
					</tr>
				</table>
			</div>
		</td>
		<td></td>
	</tr>
</table>
<!-- /body -->

<!-- footer -->
<table class="footer-wrap">
	<tr>
		<td></td>
		<td class="container">
			<div class="content"  style="padding: 10px; background-color: #d2d2d2">
				<table>
					<tr>
						<td align="center" style="font-size: smaller;">
							<!--p>Don't like these annoying emails? <a href="#"><unsubscribe>Unsubscribe</unsubscribe></a>.
							</p-->
							<strong>+ 7 863 251-63-54</strong> |
							<strong><a href="emailto:info@{$domain}">info@{$domain}</a></strong>
						</td>
					</tr>
				</table>
			</div>
			<!-- /content -->

		</td>
		<td></td>
	</tr>
</table>
<!-- /footer -->

</body>
</html>