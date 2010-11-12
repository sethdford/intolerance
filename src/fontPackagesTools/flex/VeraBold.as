package {

	import flash.display.Sprite;

	/*
		"unicodeRange" defines which chars you want to embed,
		choose one from:
	
		Uppercase
		Lowercase
		Numerals
		Punctuation
		Basic Latin
		Japanese Kana
		Japanese Kanji - Level 1
		Japanese (All)
		Basic Hangul
		Hangul (All)
		Traditional Chinese - Level 1
		Traditional Chinese (All)
		Simplified Chinese - Level 1
		Chinese (All)
		Thai
		Devanagari
		Latin I
		Latin Extended A
		Latin Extended B
		Latin Extended Add'l
		Greek
		Cyrillic
		Armenian
		Arabic
		Hebrew
			
		"fontFamily" sets the name of the font
		
		fontWeight="bold" has to be used when embedding bold face
		
	*/
	public class VeraBold extends Sprite {
		[Embed(source="../fonts/Vera-Bold.ttf", fontFamily="Bitstream Vera Sans", fontWeight="bold", unicodeRange="Basic Latin")]
		public static const font:Class		
	}
	
}