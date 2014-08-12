# Takipi test manifest, add a valid Takipi secret key
$secret_key = 'YOUR_KEY_HERE'
Exec {
    path => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
}
class {'takipi' :
  secret_key  => 'YOUR_KEY'
} ->
exec { 'check if Takipi is configured correctly':
  command   => "grep '${secret_key}' /opt/takipi/work/secret.key;
                if [ $? -eq 0 ]; then 
                  echo 'Takipi installed with key ${secret_key}'; 
                else 
                  echo 'Fail! Is ${secret_key} valid?'; 
                fi",
  provider  => shell,
  logoutput => true,
}
