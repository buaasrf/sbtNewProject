#!/bin/bash - 
###########
#this script try to creat sbt project
#
##########

echo "当前目录是："`pwd`

echo "请输入项目名称，如果不如将使用默认的项目名称project_name："

read project_name

if [ $project_name"_" = "_" ]
then
       project_name="sbt_project"
       echo "你没有输入任何项目的名称，将为你使用默认的项目名称[$project_name]"	
fi

if [ -d $project_name ] ;then
	echo "$project_name已经存在"
	exit 1
fi

echo "请输入项目的版本号，默认是0.1-SNAPSHOT:"
read project_version
if [ $project_version"_" = "_" ]
then
	project_version="0.1-SNAPSHOT"
	echo "你没有输入项目版本号，将使用默认版本:${project_version}"
fi

echo "请输入scala的版本，默认使用2.10.0："
read scala_version

if [ $scala_version"_" = "_" ]
then 
	scala_version="2.10.0"
	echo "没有输入scala版本将为你使用默认的scala版本${scala_version}"
fi

echo "请输入sbt的版本，默认使用0.12.3:"
read sbt_version

if [ $sbt_version"_" = "_" ]
then
	sbt_version="0.12.3"
	echo "没有输入sbt版本，将为您使用默认的sbt版本${sbt_version}"
fi

echo "请输入 organization,默认是com.example:"
read project_organization
if [ $project_organization"_" = "_" ]
then
	project_organization="com.example"
	echo "你没有输入organization,将使用默认的:${project_organization}"
fi

current_dir=`pwd`

if [ -w $current_dir ]
then
	mkdir -p $project_name/project
	mkdir -p $project_name/src/main/scala
	echo "$project_name/src/main/scala/${project_organization//.//}"
	tmp_dir="$project_name/src/main/scala/${project_organization//.//}"
	mkdir -p $tmp_dir
	 	
	cat > $tmp_dir/${project_name}.scala << example_scala
package ${project_organization}

/**
*
*/

object ${project_name} {
	def main(args:Array[String]){
		println("Hello world!")
	}
}
example_scala
	
	mkdir -p $project_name/src/main/resources
	mkdir -p $project_name/src/test/scala
	mkdir -p $project_name/src/test/resources

	cat > $project_name/build.sbt << build_sbt
name:="${project_name}"

scalaVersion:="${scala_version}"

version:="${project_version}"

#libraryDependencies += "com.dajie.profile" % "dj-profile-api" % "1.2.03" excludeAll(
#ExclusionRule(organization = "com.dajie",name = "dj-infra-user-api"),
#ExclusionRule(organization = "com.dajie",name = "dj-infra-user-client"),
#ExclusionRule(organization = "com.dajie.common",name = "dajie-common-dubbo")
#)

build_sbt

	cat > $project_name/project/build.properties << build_properties
sbt.version=${sbt_version}
build_properties

	cat > $project_name/project/plugins.sbt << plugins
addSbtPlugin("com.github.mpeltonen" % "sbt-idea" % "1.4.0")
plugins

	cat > $project_name/project/Build.scala << build_scala
package ${project_name}
import sbt._
import sbt.Keys._

object ${project_name}Build extends Build{
	lazy val ${project_name}: Project = Project(
		"${project_name}",
		file("."),
		settings = Defaults.defaultSettings
	)
}
build_scala
else
	echo "$current_dir不可写，无法建项目"
fi
