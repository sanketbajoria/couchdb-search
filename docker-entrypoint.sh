#!/bin/bash
# Licensed under the Apache License, Version 2.0 (the "License"); you may not
# use this file except in compliance with the License. You may obtain a copy of
# the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
# WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
# License for the specific language governing permissions and limitations under
# the License.

node=3
lastarg=""
for var in "$@"
do
	if [ "$lastarg" == "-n" ]
	then
		node=$var
	fi
	lastarg=$var
done
echo "Setup $node nodes"

#Start Couchdb
echo "Starting Couchdb"
/usr/src/couchdb/dev/run "$@" &

#Start clouseau nodes
cd /usr/src/clouseau
for ((i=1; i<=$(($node)); i++))
do
   sleep 10
   echo "Starting Clouseau $i"
   mvn scala:run -Dlauncher=clouseau$i &
   sleep 20
done


trap "trap - SIGTERM && kill -- -$$" SIGINT SIGTERM EXIT
wait