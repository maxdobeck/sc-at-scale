# Get an arbitrary file onto a real device 
In this example we download a file (PDF) from the native web browser onto the device's disk. The file type and server hosting the file are placeholders, you can use whatever is needed. In fact you can skip docker altogether as long as Sauce Connect can reach the file you're targeting.

1. docker compose up
2. the services are started
    - the simple file server is started
    - the Sauce Connect tunnels are started in both regions
3. end users can begin testing. 
4. users can download the target file from the device's browser. It will be saved to disk but eventually the disk will be cleaned and all files destroyed by Sauce Lab's cleaning service.

## Why use the browser? 
Users could use the Appium API to pushFile or pullFile as needed but in some cases this API isn't supported or may be flaky for other reasons (like outdated documentation). Automating the manual steps to download a file on iOS and Android should cover most devices available on Sauce Labs. Then users can test this and rely on this pre-hook/setup step in their suites. 