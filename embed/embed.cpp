#include <vector>
#include <string>
#include <string_view>
#include <fstream>
#include <filesystem>
#include <iostream>

/*
	Load a manifest file.
	Run through it line by line, assume each line is either blank, a comment, or a filepath.
	All filepaths in the manifest are interpreted as relative to the location of the manifest, or a working directory.
	Each file will be loaded as binary, put into a character array, and a size will be stored with it.
	A header will be generated defining the array of embedded files, and a cmake target will be created to encapsulate it.


	Usage
	 cembed -i <manifest_file> -o <output_file>

	Options
	 --version                   = Print a version string
	 --help                      = Print this help string
	 --output,-o    <name>       = (REQUIRED) Specify the name of the source file to generate, expects something like {name}.c
	 --input,-i     <manifest>   = (REQUIRED) The location of the manifest file to use, must be an actual filename
	 --header       <name>       = Specify the name of the header file to generate, otherwise inferred from output name
	 --dir,-d       <directory>  = Change the working directory to source manifest files from
	 --namespace,-n <name>       = Specify a custom namespace for the embedded files
*/

/*
// predefined text
static constexpr char filedef[] = "static const char file";
static constexpr char filestart[] = "[] = { ";
static constexpr char fileend[] = " };";

static constexpr char 
*/

enum class Token {
	Version,
	Help,
	Output,
	Input,
	Header,
	Directory,
	Path,
	Invalid
};

struct TokenData {
	Token type;
	std::string_view text;
};

Token parse(std::string_view text) {
	if (text.size() == 0) {
		return Token::Invalid;
	}

	switch (text[0]) {
	case '\0':
		return Token::Invalid;
	case '-': {
		if (text == "--help") {
			return Token::Help;
		}
		else if (text == "-i" || text == "--input") {
			return Token::Input;
		}
		else if (text == "-o" || text == "--output") {
			return Token::Output;
		}
		else if (text == "-d" || text == "--dir") {
			return Token::Directory;
		}
		else if (text == "--header") {
			return Token::Header;
		}
		else if (text == "--version") {
			return Token::Version;
		}
		else {
			return Token::Invalid;
		}
	}
	default:
		return Token::Path;
	}
}

namespace fs = std::filesystem;

static const std::string_view versionString{
	"cembed version 0.1.0\n"
};

static const std::string_view helpString{
	"Usage\n"
	" cembed - i <manifest_file> -o <output_file>\n\n"

	"Options\n"
	" --version = Print a version string\n"
	" --help = Print this help string\n"
	" --output,-o <name> = (REQUIRED) Specify the name of the source file to generate, expects something like {name}.c\n"
	" --input,-i  <manifest> = (REQUIRED) The location of the manifest file to use, must be an actual filename\n"
	" --header    <name> = Specify the name of the header file to generate, otherwise inferred from output name\n"
	" --dir,-d    <directory> = Change the working directory to source manifest files from\n"
};

int main(int argc, char* argv[]) {
	std::vector<TokenData> tokens;
	for (int i = 1; i < argc; ++i) {
		std::string_view text{argv[i]};
		Token type = parse(text);

		switch (type) {
		case Token::Help:
			std::cout << helpString;
			return 0;
		case Token::Version:
			std::cout << versionString;
			return 0;
		case Token::Invalid:
			std::cerr << "Argument '" << text << "' at position " << i << " is invalid!\n";
			return -1;
		default:
			break;
		}

		tokens.push_back(
			TokenData{
				type,
				text
			}
		);
	}



	return 0;
}