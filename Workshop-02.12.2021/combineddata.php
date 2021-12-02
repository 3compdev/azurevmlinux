<?php
//   $host="111";
//    $user="admin";
//    $pass="Geneva203";
//    $DB="ukdb";

    $con=mysqli_connect('192.168.100.221:3306','admin','Geneva203','ukdb');

    if(!$con)
    {
        die("DB Connection Failed");
    }


     $con1=mysqli_connect('172.31.46.246:3306','usdb','Geneva203!','usdb');

    if(!$con1)
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

               <?php
                $sql="select * from peoples";
                $rs=mysqli_query($con1,$sql);
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
