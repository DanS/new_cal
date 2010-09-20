module GenImgHelpers

  def dec2bin(number)
    ## Function to convert a given decimal number into binary string
    number = Integer(number);
    if(number == 0)
      return '0';
    end
    ret_bin = "";
    ## Untill val is zero, convert it into binary format
    while(number != 0)
      ret_bin = String(number % 2) + ret_bin;
      number = number / 2;
    end
    return ret_bin;
  end

  def bin2dec(number)
    ## Function to convert a given binary string into decimal number
    ret_dec = 0;
    number.split(//).each do |digit|
      ret_dec = (Integer(digit) + ret_dec) * 2;
    end
    return ret_dec/2;
  end

  def number2letters(num)
    #return the letters (colors) coresponding to a given number
    letters = Destination.all.collect {|d| d.letter}.sort
    bin_string = dec2bin(num).rjust(8, '0')
    output = ''
    for i in (0..7)
      if bin_string[i, 1] == '1'
        output += letters[i]
      end
    end
    return output
  end

  def gen_image(name)
    #creates img used to colorize calendar days
    #is a 'stack' of 1 to 8 colors, a different color for each letter in name
    # no idea how to spec or test this
    vert_list = ImageList.new
    colors = {}
    Destination.all.map {|d| colors[d.letter] = d.color}
    height_of_each_color = 31.0 / name.length
    for color_key in name.split(//)
      color = colors[color_key]
      vert_list << Image.new(1,height_of_each_color) {self.background_color = color}
    end

    img = vert_list.append(true)
    img_path = RAILS_ROOT + '/public/images'
    img.write("#{img_path}/#{name}.jpg")
  end
end
