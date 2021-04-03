#include <iostream>
#include <fstream>
#include <string>

int main(int argc, const char *argv[])
{
	if(argc != 4)
	{
		std::cout << "Usage: in.obj out.lua variable_name_prefix\n";
		return 0;
	}

	std::ifstream in_file(argv[1]);
	if(!in_file.is_open())
	{
		std::cout << "Cannot open input file!\n";
		return -1;
	}

	std::ofstream out_file(argv[2]);
	if(!out_file.is_open())
	{
		std::cout << "Cannot open output file!\n";
		return -1;
	}

	const char* prefix = argv[3];

	bool writing_vertices = false;
	bool writing_triangles = false;
	bool new_array = true;
	std::string color;

	std::string token;
	while(in_file >> token)
	{
		if(token == "o")
		{
			if(writing_triangles || writing_vertices)
			{
				out_file << "}\n";
				writing_triangles = false;
			}

			out_file << prefix << "vertices={\n";
			writing_vertices = true;
			new_array = true;
			continue;
		}

		if(token == "usemtl")
		{
			if(writing_vertices)
			{
				out_file << "}\n";
				writing_vertices = false;
			}

			if(!writing_triangles)
			{
				out_file << prefix << "triangles={\n";
				writing_triangles=true;
				new_array = true;
			}
			
			in_file >> color;
			continue;
		}
			
		if(token == "v")
		{
			out_file << (new_array ? "  " : " ,");
			in_file >> token;	out_file << token << ",";				// X
			in_file >> token;	out_file << -std::stof(token) << ",";	// Y (inverted)
			in_file >> token;	out_file << token;						// Z
			out_file << "\n";
			new_array = false;
			continue;
		}

		if(token == "f")
		{
			out_file << (new_array ? "  " : " ,");
			in_file >> token;	out_file << std::stoi(token)-1 << ",";	// shift by 1, obj is 1 based index
			in_file >> token;	out_file << std::stoi(token)-1 << ",";	// shift by 1, obj is 1 based index
			in_file >> token;	out_file << std::stoi(token)-1;			// shift by 1, obj is 1 based index
			out_file << color << "\n";
			new_array = false;
			continue;
		}
	}

	if(writing_vertices || writing_triangles)
	{
		out_file << "}\n";
	}

	std::cout << "DONE\n";
}
