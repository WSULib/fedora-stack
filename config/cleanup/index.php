<?php
	$VM_NAME = getenv('VM_NAME');
	$VM_HOST = getenv('VM_HOST');
?>
<html>
	
	<head>
		<title><?php echo $VM_NAME; ?></title>
	</head>

	<body>
		
		
		<h2>Welcome to <?php echo $VM_NAME; ?>!</h2>

		<p>
			Github Repo: <a target="_blank" href='https://github.com/WSUlib/<?php echo $VM_NAME; ?>.git'><?php echo $VM_NAME; ?></a><br>
			Host / IP: <?php echo $VM_HOST; ?>
		</p>

		<p>Components:</p>
		<ul>
			<li><a target="_blank" href="http://<?php echo $VM_HOST; ?>:8080">Tomcat</a></li>
			<li><a target="_blank" href="http://<?php echo $VM_HOST; ?>/fedora/admin">Fedora Commons Admin</a></li>
			<li><a target="_blank" href="http://<?php echo $VM_HOST; ?>/fedora/risearch">Fedora Commons Risearch</a></li>
			<li><a target="_blank" href="http://<?php echo $VM_HOST; ?>/solr4">Solr</a></li>
			<li><a target="_blank" href="http://<?php echo $VM_HOST; ?>/ouroboros">Ouroboros</a></li>
			<li><a target="_blank" href="http://<?php echo $VM_HOST; ?>/digitalcollections">Digital Collections Front-End</a></li>
		</ul>

	</body>

</html>