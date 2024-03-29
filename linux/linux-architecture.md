# Architecture  

### To find the architecture of your Linux machine, you can use the uname command with the -m flag. Here's how:  

Open your terminal and type:  
```
uname -m
```

This command will output the machine hardware name, which typically indicates the architecture.   
Common architecture names include x86_64 for 64-bit systems, arm for ARM-based systems, and arm64 for 64-bit ARM systems.  

Based on the output, you can determine the appropriate value for the TARGETARCH environment variable in your Dockerfile. For example:  

If the output is **x86_64**, you can set TARGETARCH to "**linux-x64**".  
If the output is **arm**, you can set TARGETARCH to "**linux-arm**".  
If the output is **aarch64** or **arm64**, you can set TARGETARCH to "**linux-arm64**".  
Make sure to use the appropriate value based on the architecture of your machine.  
