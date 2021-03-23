#!/usr/bin/env bash

# Find FontForge
if command -v fontforge >/dev/null 2>&1; then
	FONTFORGE="fontforge"
elif test -f /Applications/FontForge.app/Contents/Resources/opt/local/bin/fontforge; then
	FONTFORGE="/Applications/FontForge.app/Contents/Resources/opt/local/bin/fontforge"
else
	echo "Could not find FontForge."
	exit 1
fi

# Find Bits'n'Picas
if test -f BitsNPicas.jar; then
	BITSNPICAS="java -jar BitsNPicas.jar"
elif test -f ../BitsNPicas/BitsNPicas.jar; then
	BITSNPICAS="java -jar ../BitsNPicas/BitsNPicas.jar"
elif test -f ../Workspace/BitsNPicas/BitsNPicas.jar; then
	BITSNPICAS="java -jar ../Workspace/BitsNPicas/BitsNPicas.jar"
elif test -f ../../BitsNPicas/BitsNPicas.jar; then
	BITSNPICAS="java -jar ../../BitsNPicas/BitsNPicas.jar"
elif test -f ../../Workspace/BitsNPicas/BitsNPicas.jar; then
	BITSNPICAS="java -jar ../../Workspace/BitsNPicas/BitsNPicas.jar"
elif test -f ../../../BitsNPicas/BitsNPicas.jar; then
	BITSNPICAS="java -jar ../../../BitsNPicas/BitsNPicas.jar"
elif test -f ../../../Workspace/BitsNPicas/BitsNPicas.jar; then
	BITSNPICAS="java -jar ../../../Workspace/BitsNPicas/BitsNPicas.jar"
elif test -f ../../../../BitsNPicas/BitsNPicas.jar; then
	BITSNPICAS="java -jar ../../../../BitsNPicas/BitsNPicas.jar"
elif test -f ../../../../Workspace/BitsNPicas/BitsNPicas.jar; then
	BITSNPICAS="java -jar ../../../../Workspace/BitsNPicas/BitsNPicas.jar"
else
	echo "Could not find BitsNPicas."
	exit 1
fi

# Find ttf2eot
if command -v ttf2eot >/dev/null 2>&1; then
	TTF2EOT="ttf2eot"
else
	echo "Could not find ttf2eot."
	exit 1
fi

# Clean
rm -f KreativeSquare.sfd-* KreativeSquare.ttf KreativeSquare.eot KreativeSquare.zip KreativeSquareSM.*
rm -rf kreativesquare

# Make strict monospace version
python sfdpatch.py KreativeSquare.sfd strictmono.txt > KreativeSquareSM.sfd

# Generate ttf
$FONTFORGE -lang=ff -c 'i = 1; while (i < $argc); Open($argv[i]); Generate($argv[i]:r + ".ttf", "", 0); i = i+1; endloop' \
	KreativeSquare.sfd KreativeSquareSM.sfd

# Inject PUAA table
$BITSNPICAS injectpuaa \
	-D Blocks.txt UnicodeData.txt \
	-I KreativeSquare.ttf KreativeSquareSM.ttf

# Convert to eot
$TTF2EOT < KreativeSquare.ttf > KreativeSquare.eot
$TTF2EOT < KreativeSquareSM.ttf > KreativeSquareSM.eot

# Create zip
zip KreativeSquare.zip OFL.txt KreativeSquare*.ttf KreativeSquare*.eot

# Create lowercase versions
mkdir kreativesquare
cp KreativeSquare.ttf kreativesquare/kreativesquare.ttf
cp KreativeSquare.eot kreativesquare/kreativesquare.eot
cp KreativeSquareSM.ttf kreativesquare/kreativesquaresm.ttf
cp KreativeSquareSM.eot kreativesquare/kreativesquaresm.eot
cp KreativeSquare.zip kreativesquare/kreativesquare.zip
