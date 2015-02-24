package;
import haxe.crypto.Md5;

/**
 * ...
 * @author Loutchansky Oleg
 */
class LToken
{
	static var secret : String;	
	static var randomDistance : Int;
	
	static var DEVIDER = "/";
	
	/**
	 * Инициализация приложения
	 * @param	secretKey - секретный ключ приложения
	 * @param	randomDistance - количество случайных ключей
	 */
	public static function init(secretKey : String, randomDistance : Int = 100000)
	{
		this.secret = secretKey;
		this.randomDistance = randomDistance;
		
		return true;
	}
	
	/**
	 * Генерация ключа
	 * @param	time - количество дней в течении которых ключ активен c момента активации (если ключ бесконечный установить значение в ноль)
	 * @return возрашает сгенерированный ключ
	 */
	public static function generate(time : Int = 0) : String
	{
		var rand = Math.random() * RANDOM_DISTANCE;
		
		return rand + DEVIDER + Md5.encode(secret + time + rand) + DEVIDER + time;
	}
	
	/**
	 * Генерация ключа по параметрам
	 * @param	time - время
	 * @param	rand - случайное число
	 */
	public static function generateHashOnly(time : Int = 0, rand : Int = 0)
	{
		return Md5.encode(secret + time + rand);
	}
	
	/**
	 * Проверка валидности ключа
	 * @param	key - ключ, который необходимо проверить
	 * @return возращает количество дней ключа, если количество дней 0, то ключ бесконечный, если количество дней -1, то ключ неверен.
	 */
	public static function check(key : String) : Bool
	{
		var rand = 0;
		var time = 0;
		var hash : String;
		var valid = false;
		
		try 
		{
		
			hash = key.substring(key.indexOf(DEVIDER), key.lastIndexOf(DEVIDER));
			rand = Std.parseInt(key.substring(0, key.indexOf(DEVIDER)));
			time = Std.parseInt(key.substring(key.lastIndexOf(DEVIDER), key.length));
			
			if (hash == generateHashOnly(time, rand))
			{
				valid = true;
			}
		
		}
		catch (e : Dynamic)
		{
			valid = false;
		}
		
		return valid;
	}
	
	/**
	 * Возращает количество дней, на которое можно использовать ключ
	 * Этой функцией нельзя проверять ключ!
	 * @param	key
	 * @return возращает, если ключ неправильный
	 */
	public static function getDays(key : String) : Int
	{
		var rand = 0;
		var time = 0;
		var hash : String;
		
		try 
		{
		
		hash = key.substring(key.indexOf(DEVIDER), key.lastIndexOf(DEVIDER));
		rand = Std.parseInt(key.substring(0, key.indexOf(DEVIDER)));
		time = Std.parseInt(key.substring(key.lastIndexOf(DEVIDER), key.length));
		
		}
		catch (e : Dynamic)
		{
			time = -1;
		}
		
		return time;
	}
}