# Curl Command  


## Basic Usage  
```
curl http://159.89.136.82:32070/
```

Curl, short for "Client URL," is a command-line tool and library for transferring data with URLs. It supports various protocols, including HTTP, HTTPS, FTP, FTPS, and more.  

### Here's a breakdown of how to use Curl:  

#### 1. Basic Usage:
To use Curl, open your command-line interface (Terminal on macOS/Linux, Command Prompt on Windows) and type curl followed by the URL you want to access.

##### Example: 
```
curl https://www.example.com
```  
#### 2. Saving Output to a File:
You can save the output of a Curl request to a file using the -o flag followed by the filename.
##### Example:  
```
curl -o output.html https://www.example.com
```

#### 3. Following Redirects:
By default, Curl does not follow redirects. To enable automatic following of redirects, use the -L flag.

#####  Example:  
```
curl -L https://www.example.com
```

#### 4. Sending Data:
Curl can also be used to send data to a server using different methods such as POST, PUT, or DELETE. Use the -X flag followed by the HTTP method, and include data using the -d flag.

#####  Example (POST request with data):  
```
curl -X POST -d "username=user&password=pass" https://www.example.com/login
```

#### 5. Setting Headers:
You can include custom headers in your Curl requests using the -H flag.

##### Example: 
```
curl -H "Authorization: Bearer token" https://www.example.com/api/data
```

#### 6. Verbose Output:
To see detailed information about the Curl request and response, use the -v flag for verbose output.

##### Example:  
```
curl -v https://www.example.com
```

These are some common uses of Curl, but it offers many more features and options for handling various types of requests and responses. You can explore its extensive documentation for more advanced usage.
