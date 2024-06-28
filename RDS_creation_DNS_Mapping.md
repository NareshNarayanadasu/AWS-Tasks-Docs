# Steps to Deploy RDS and Connect via MySQL Workbench

## 1. Deploy RDS/Azure SQL

### AWS RDS
1. **Log in to AWS Management Console**.
2. **Navigate to RDS Service**.
3. **Click on 'Create database'**.
4. **Select 'Standard Create'**.
5. **Choose Engine**: Select MySQL.
6. **Version**: Choose the desired MySQL version.
7. **Templates**: Select 'Production' or 'Free tier' as per requirement.
8. **Settings**: Provide DB instance identifier, master username, and password.
9. **DB instance size**: Select the instance size.
10. **Storage**: Configure storage settings.
11. **Connectivity**: 
    - **Virtual Private Cloud (VPC)**: Select the VPC.
    - **Subnet group**: Select a DB subnet group.
    - **Public access**: Choose 'No' for private endpoint.
12. **Additional configuration**: Configure additional settings.
13. **Create database**.

### Azure SQL
1. **Log in to Azure Portal**.
2. **Navigate to 'SQL databases'**.
3. **Click on 'Create'**.
4. **Basics**: Fill in project details and database details.
5. **Networking**: Choose private endpoint connectivity.
6. **Additional settings**: Configure additional settings.
7. **Review + create**: Review the configuration and click 'Create'.

## 2. Map DNS Record in Route 53/Private DNS

1. **Navigate to Route 53** in the AWS Management Console.
2. **Hosted zones**: Select the hosted zone for your domain.
3. **Create record**:
    - **Record name**: Enter the subdomain or name you want to use.
    - **Record type**: Select 'CNAME' or 'A'.
    - **Value**: Enter the endpoint of your RDS instance.
4. **Save the record**.

## 3. Install MySQL Workbench

1. **Download MySQL Workbench**: Go to the [MySQL Workbench download page](https://dev.mysql.com/downloads/workbench/).
2. **Install MySQL Workbench**: Follow the installation instructions for your operating system.

## 4. Connect to the RDS via MySQL Workbench

1. **Open MySQL Workbench**.
2. **Create a new connection**:
    - **Connection name**: Enter a name for the connection.
    - **Hostname**: Enter the DNS name mapped in Route 53.
    - **Port**: Use the default MySQL port (3306) or the port specified during RDS creation.
    - **Username**: Enter the master username.
    - **Password**: Enter the master password.
3. **Test connection**: Click on 'Test Connection' to verify connectivity.
4. **Save and connect**: Click 'OK' to save the connection and connect to the RDS instance.
