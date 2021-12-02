<?php
    $host="localhost";
    $user="usdb";
    $pass="Geneva203!";
    $DB="usdb";
    
    $con=mysqli_connect($host,$user,$pass,$DB);
    
    if(!$con)
    {
        die("DB Connection Failed");
    }
    
?>
<html>
    <head>
        <title>
            Fetch Data
        </title>
    </head>
    <body>
        <table border="1" cellspacing="5" cellpadding="5" width="600">
            <tr>
                <th>
                    Name
                </th>
                <th>
                    Mobile
                </th>
                <th>
                    Age
                </th>
                <th>
                    Email
                </th>
                
            </tr>
            <?php
                $sql="select * from peoples";
                $rs=mysqli_query($con,$sql);
                while($res=mysqli_fetch_object($rs))
                {
            ?>
            
                    <tr>
                        <td>
                            <?php echo $res->name; ?>
                        </td>
                        <td>
                            <?php echo $res->mobile; ?>
                        </td>
                        <td>
                            <?php echo $res->age; ?>
                        </td>
                        <td>
                            <?php echo $res->email; ?>
                        </td>
                        
                    </tr>
            <?php
                }
            ?>
        </table>
    </body>
</html>