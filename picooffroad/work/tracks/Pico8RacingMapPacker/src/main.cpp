#include <stdio.h>
#include <vector>

char* pico8chars[256];

template<typename T> inline T Max(T a,T b) { return a>b ? a : b; }
template<typename T> inline T Min(T a,T b) { return a<b ? a : b; }

void LoadPico8Chars()
{
	FILE* f_in = fopen("pico8chars.utf8", "rt");
	for(int i=0;i<32;++i)
	{
		pico8chars[i]=nullptr;
	}

	pico8chars[32] = new char[2];
	strcpy(pico8chars[32]," "); // space is problematic in fscanf

	for(int i=33;i<=255;++i)
	{
		char tmp[16];
		int len = fscanf(f_in, "%s", tmp);
		pico8chars[i] = new char[strlen(tmp)+1];
		strcpy(pico8chars[i], tmp);
	}

	fclose(f_in);
}

void DeallocPico8Chars()
{
	for(int i=0;i<=255;++i)
	{
		delete pico8chars[i];
	}
}

int EmmitRLEOutput(FILE* f, char c,int count,int& max_waypoint_index)
{
	if(count == 0)
	{
		return 0;
	}

	int written = 0;
	if(count > 1)
	{
		written += fprintf(f,"%i",count);
	}

	if(c>='A' && c<='Z')
	{
		// barrier
		written += fprintf(f,"%c|",c-'A'+'a');
	}
	else if(c>='!' && c<='/')
	{
		// waypoint (stored as slippery surface - because that has height copied from previous tile, value is stored as flag)
		written += fprintf(f,"_%c",c);
		c-='!';
		max_waypoint_index = (c>max_waypoint_index) ? c : max_waypoint_index;
	}
	else
	{
		// standard tile
		written += fprintf(f,"%c",c);
	}

	return written;
}

void ProcessStartPosition(char& c, int index, std::vector<int>& start_position_index)
{
	if(c>='0' && c<='7')
	{
		start_position_index[c-'0'] = index;
		c='_';
	}
}

int main(int argc,char *argv[])
{
	if(argc!=4)
	{
		printf("Usage: Pico8RacingMapPacker src dst prefix\n");
		return 0;
	}

	LoadPico8Chars();

	const int map_width = 64;
	const int map_height = 64;

	/*
	// create empty map
	{
		FILE* f = fopen(argv[2],"wt");
		char line[map_width*2+1];
		for(int row=0;row<map_height;++row)
		{
			int w=0;
			for(int space=0;space<row/2;++space)
			{
				line[w++]='.';
			}
			for(int fill=0;fill<map_width;++fill)
			{
				line[w++]='a';
			}
			for(int space=0;space<(map_height/2-row/2);++space)
			{
				line[w++]='.';
			}
			line[w]=0;

			fprintf(f,"%s\n",line);
		}
		fclose(f);
		return 0;
	}
	*/

	// create tile stream
	std::vector<char> tile_stream;

	FILE* f_in = fopen(argv[1], "rt");
	FILE* f_out= fopen(argv[2], "wt");
	FILE* f_dump=fopen("dump.txt","wt");

	fprintf(f_out,"%s[[",argv[3]); // prefix
	char line[1024];
	for(int row=0;row<map_height;++row)
	{
		fscanf(f_in,"%s\n",line);

		int chars_to_move = row/2;
		for(int column=0;column<chars_to_move;++column)
		{
			line[column] = line[map_width+column];
		}
		line[map_width] = 0;
		//fprintf(f_out,"%s\n",line); // partial result

		for(int i=0;i<map_width;++i)
		{
			tile_stream.push_back(line[i]);
		}
	}

	/*
	// RLE
	char current= 0;
	char last   = 0;
	int count   = 0;
	int written = 0;
	int max_waypoint_index = -1;
	std::vector<int> start_positions(8,0);
	
	for(int index=0;index<tile_stream.size();++index)
	{
		char c = tile_stream[index];
		ProcessStartPosition(c, index, start_positions);

		if(c!=current)
		{
			written += EmmitRLEOutput(f_out, current, count, max_waypoint_index);
			last    = current;
			current = c;
			count   = 1;
		}
		else
		{
			++count;
		}
	}
	written += EmmitRLEOutput(f_out, current, count, max_waypoint_index);
	*/

	// find and preprocess starting points
	std::vector<int> start_positions(8,0);
	for(size_t index=0; index<tile_stream.size(); ++index)
	{
		char c=tile_stream[index];
		if(c>='0' && c<='7')
		{
			start_positions[c-'0'] = index;
			tile_stream[index]='_';
		}
	}

	// transform and analyse characters before compression
	int max_waypoint_index = -1;
	for(size_t index=0; index<tile_stream.size(); ++index)
	{
		char c=tile_stream[index];
		if(c=='_')
		{
			tile_stream[index] = 189;
		}
		else if(c=='~')
		{
			tile_stream[index] = 190;
		}
		else if(c>=33 && c<=47)
		{
			tile_stream[index] = 191 + (c-33);
			max_waypoint_index = Max(max_waypoint_index, c-33);
		}
		else if(c>='a' && c<='y')
		{
			tile_stream[index] = 206 + (c-'a');
		}
		else // A..Y
		{
			tile_stream[index] = 231 + (c-'A');
		}
	}

	// LZ77
	int dump_row=0;

	int count   = 0;
	int written = 0;
	
	int index=0;
	while(index<tile_stream.size())
	{
		int offset=0;
		int length=0;
		for(int search=Max(index-95,0); search<index; ++search)
		{
			if(tile_stream[search] == tile_stream[index])
			{
				int l=1,i=1;
				while(index+l < tile_stream.size() && tile_stream[search+l]==tile_stream[index+l]) ++l;

				if(l > length)
				{
					offset = index - search;
					length = l;
				}
			}
		}

		if(length > 2)
		{
			fprintf(f_dump,"%i: %i,%i\n",dump_row++,offset,length);
			length = Min(length - 3, 194);
			fprintf(f_out,"%s%s",pico8chars[94+offset-1],pico8chars[length <= 32 ? length + 32 : length - 33 + 94]);
			index += length + 3;
		}
		else
		{
			fprintf(f_dump,"%i: %i\n",dump_row++,(int)(unsigned char)tile_stream[index]);
			fprintf(f_out,"%s",pico8chars[(unsigned char)tile_stream[index]]);
			++index;
		}
	}

	fprintf(f_out,"]]\n");
	fprintf(f_out,"waypoints_%s%i\n",argv[3],max_waypoint_index+1);
	fprintf(f_out,"starts_%ssplit('",argv[3]);
	for(int i=0; i<start_positions.size(); ++i)
	{
		fprintf(f_out,"%i%s",start_positions[i], i+1==start_positions.size() ? "')\n":",");
	}
		
	fclose(f_dump);
	fclose(f_out);
	fclose(f_in);

	printf("Size: %i -> %i\n",map_width*map_height, written);
	DeallocPico8Chars();
	return 0;
}


