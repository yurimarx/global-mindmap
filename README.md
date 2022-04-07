## About Global-Mindmap Application
 [![Quality Gate Status](https://community.objectscriptquality.com/api/project_badges/measure?project=intersystems_iris_community%2Fglobal-mindmap&metric=alert_status)](https://community.objectscriptquality.com/dashboard?id=intersystems_iris_community%2Fglobal-mindmap)

This is a Mindmap application using globals to store mindmap nodes

## Installation using ZPM
1. Execute this command from IRIS Terminal:
```
zpm "install global-mindmap"
```
2. Access Mindmap UI: http://localhost:52773/mindmap/index.html

## Installation using Docker Compose
1. Clone/git pull the repo into any local directory

```
$ git clone https://github.com/yurimarx/global-mindmap.git
```

2. Open a Docker terminal in this directory and run:

```
$ docker-compose build
```

3. Run the IRIS container:

```
$ docker-compose up -d 
```

4. Go to http://localhost:3000 or http://localhost:52773/mindmap/index.html to use the Mindmap frontend and create mindmaps like this:

![Mindmap](https://github.com/yurimarx/global-mindmap/raw/main/mindmap.gif "Mindmap")

# If you want to test backend API services
1. Go to Terminal, namespace IRISAPP:
```
USER>zn "IRISAPP"
```
2. Set UnitTest Suite folder
```
IRISAPP>Set ^UnitTestRoot="/opt/irisbuild/src"
```
3. Execute unit tests
```
IRISAPP>do ##class(%UnitTest.Manager).RunTest("UnitTests")
```
4. See test results in http://localhost:52773/csp/sys/%25UnitTest.Portal.Indices.cls?Index=1&$NAMESPACE=IRISAPP

# Credits
This application used mind-elixir project
