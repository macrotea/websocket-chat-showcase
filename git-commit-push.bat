rem author: macrotea@qq.com / @Macrotea / macrotea.cn

@echo off

:: get user input content
set /p repoType=is it git@oschina repository? (y or n) :

set /p repoName=input your repository name :

:: set /p projectTypeNumber=input your project type number (1:java 2:web 3:nodejs) :

:: config README file content
touch README.md
echo.##  %repoName%  ## >>README.md

:: config gitignore file content
touch .gitignore
:: if /i '%projectTypeNumber%'=='1' (
:: 	echo.#IDEA >>.gitignore
:: 	echo..idea >>.gitignore
:: 	echo.out >>.gitignore
:: 	echo.*.iml >>.gitignore
:: 	echo. >>.gitignore
:: 	echo.#Eclipse >>.gitignore
:: 	echo.*.classpath >>.gitignore
:: 	echo.*.project >>.gitignore
:: 	echo.*.settings >>.gitignore
:: 	echo.*.log >>.gitignore
:: 	echo.*/target >>.gitignore
:: 	echo.target/* >>.gitignore
:: 	echo.logs >>.gitignore
:: 	echo..springBeans >>.gitignore
:: 	echo. >>.gitignore
:: 	echo.#Java >>.gitignore
:: 	echo.*.class >>.gitignore
:: 	echo.*.jar >>.gitignore
:: 	echo.*.war >>.gitignore
:: 	echo.*.ear >>.gitignore
:: 	echo. >>.gitignore
:: 	echo.#Other >>.gitignore
:: 	echo.git-push.bat >>.gitignore
:: )
:: 
:: if /i '%projectTypeNumber%'=='2' (
:: 	echo.#IDEA >>.gitignore
:: 	echo..idea >>.gitignore
:: 	echo.out >>.gitignore
:: 	echo.*.iml >>.gitignore
:: 	echo. >>.gitignore
:: 	echo.#Eclipse >>.gitignore
:: 	echo.*.classpath >>.gitignore
:: 	echo.*.project >>.gitignore
:: 	echo.*.settings >>.gitignore
:: 	echo.*.log >>.gitignore
:: 	echo.*/target >>.gitignore
:: 	echo.target/* >>.gitignore
:: 	echo.logs >>.gitignore
:: 	echo..springBeans >>.gitignore
:: 	echo. >>.gitignore
:: 	echo.#Web >>.gitignore
:: 	echo.node_modules >>.gitignore
:: 	echo. >>.gitignore
:: 	echo.#Other >>.gitignore
:: 	echo.git-push.bat >>.gitignore
:: )
:: 
:: if /i '%projectTypeNumber%'=='3' (
:: 	echo.#IDEA >>.gitignore
:: 	echo..idea >>.gitignore
:: 	echo.out >>.gitignore
:: 	echo.*.iml >>.gitignore
:: 	echo. >>.gitignore
:: 	echo.#Eclipse >>.gitignore
:: 	echo.*.classpath >>.gitignore
:: 	echo.*.project >>.gitignore
:: 	echo.*.settings >>.gitignore
:: 	echo.*.log >>.gitignore
:: 	echo.*/target >>.gitignore
:: 	echo.target/* >>.gitignore
:: 	echo.logs >>.gitignore
:: 	echo..springBeans >>.gitignore
:: 	echo. >>.gitignore
:: 	echo.#Web >>.gitignore
:: 	echo.node_modules >>.gitignore
:: 	echo. >>.gitignore
:: 	echo.#Other >>.gitignore
:: 	echo.git-push.bat >>.gitignore
:: )

:: config url
set url=
if /i '%repoType%'=='n' (
	set url=https://github.com/macrotea/%repoName%.git
)

if /i '%repoType%'=='y' (
	set url=https://git.oschina.net/macrotea/%repoName%.git
)

:: git push
git init
git add .
git commit -m 'init'
git remote add origin %url%
git push -u origin master

echo. &pause
exit