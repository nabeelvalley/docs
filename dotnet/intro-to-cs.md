# Introduction to C

From the Microsoft Virtual Academy

## Hello World

```cs
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace HelloWorld
{
    class Program
    {
        static void Main(string[] args)
        {
            Console.WriteLine("Hello, World!");
            Console.ReadLine();
        }
    }
}
```

## Variables

```cs
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Variables
{
    class Program
    {
        static void Main(string[] args)
        {
            Console.WriteLine("Some Math here : ");
            int x;
            int y;

            x = 7;
            y = x + 3;

            Console.WriteLine("x = 7");
            Console.WriteLine("y = x + 3");
            Console.WriteLine("y = " + y);

            Console.ReadLine();

            //-------------------------------------------

            Console.WriteLine("What is your name?");
            Console.Write("Type your first name : ");
            string MyFirstName = Console.ReadLine();

            Console.Write("Type your last name : ");
            string MyLastName = Console.ReadLine();

            Console.WriteLine("Hello, " + MyFirstName + " " + MyLastName + " !");
            Console.ReadLine();

        }
    }
}
```

## Decisions

```cs
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Decisions
{
    class Program
    {
        static void Main(string[] args)
        {
            Console.WriteLine("Bob's Big Giveaway");
            Console.Write("Choose a Door : 1,2 or 3 : ");
            string Selection = Console.ReadLine();

            string Prize;

            if (Selection == "1")
                Prize = "You Win a Car";

            else if (Selection == "2")
                Prize = "You Win a Goat";

            else if (Selection == "3")
                Prize = "You Win a bag of weed";

            else
            {
                Prize = "nada Bruv";
                Prize += ", You Lose";
            }

            //----------------------------------------------

            Console.WriteLine(Prize);
            Console.ReadLine();

            Console.WriteLine("Bob's Big Giveaway Part 2");
            Console.Write("Choose a Door : 1,2 or 3 : ");
            string Selection2 = Console.ReadLine();

            string Prize2 = (Selection2 == "1") ? "Boat" : "Bale of Hay";

            Console.WriteLine("You chose {0}, you Win a {1}", Selection2, Prize2);
            Console.ReadLine();


        }
    }
}
```

## For Loops

```cs
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ForIteration
{
    class Program
    {
        static void Main(string[] args)
        {
            for (int i = 0; i < 10; i++) // For loop, create variable; stop condition; increase value by one
            {
                Console.WriteLine(i);
                if (i == 7)
                {
                    Console.WriteLine("Found Seven");
                    break; // Breaks out of for loop
                }
            }
            Console.ReadLine();
        }
    }
}
```

## While Loop

```cs
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace WhileIteration
{
    class Program
    {
        static void Main(string[] args)
        {
            do
            {
                Console.Clear();
            } while (MenuOptions());

        }

        private static bool MenuOptions()
        {
            Console.WriteLine("Choose an Option:");
            Console.WriteLine("1. Write stuff");
            Console.WriteLine("2. Random Int");
            Console.WriteLine("3. Exit");

            string result = Console.ReadLine();

            if (result == "1")
            {
                Console.WriteLine("Write stuff for me to write");
                string input = Console.ReadLine();
                while (input != "")
                {
                    Console.WriteLine("You Said {0}", input);
                    input = Console.ReadLine();
                }
                return true;
            }
            else if (result == "2")
            {
                Random MyRandom = new Random();
                int RandomNum = MyRandom.Next(0, 10);
                Console.WriteLine("Guess the Int");

                bool correct;
                do
                {
                    string guess = Console.ReadLine();
                    if (guess == RandomNum.ToString())
                    {
                        correct = true;
                        Console.WriteLine("Correct!");
                        Console.WriteLine("Click Enter to end");
                    }
                    else
                    {
                        correct = false;
                        Console.WriteLine("Incorrect");
                    }
                } while (correct == false);

                Console.ReadLine();
                return true;
            }
            else if (result == "3")
            {
                return false;
            }
            else
            {
                return true;
            }
        }
    }
}
```

## Arrays

```
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Arrays
{
    class Program
    {
        static void Main(string[] args)
        {
            int[] nums = new int[5];

            nums[0] = 4;
            nums[1] = 5;
            nums[2] = 8;
            nums[3] = 43;
            nums[4] = 91;

            Console.WriteLine(nums[3]);

            int len = nums.Length;
            Console.WriteLine(len);

            int[] vals = new int[] { 1, 2, 2, 8, 3, 12, 54 };
            for (int i = 0; i < vals.Length; i++) //manually iterate through values
            {
                Console.WriteLine(vals[i]);
            }

            string[] words = new string[] { "hey", "man", "wassup" };
            foreach (string word in words) //automatically iterate through items
            {
                Console.WriteLine(word);
            }

            // we can create a string and make it an array of characters

            string me = "Nabeel Valley"; //make string
            char[] mechars = me.ToCharArray(); //convert to CharArray
            Array.Reverse(mechars); //reverse array values

            foreach (char mechar in mechars)
            {
                Console.Write(mechar);
            }

            Console.ReadLine();
        }
    }
}
```

## Functions

```cs
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SimpleMethod
{
    class Program
    {
        static void Main(string[] args)
        {
            string message = "Hello World";
            PrintStuff(message);

            PrintStuff("Hey who are you?");
            string name = Console.ReadLine();
            string[] PrintWords = new string[] { "Hello", name };

            PrintStuff(JoinWords("Hello", name)); //uses method singnature for two inputs
            PrintStuff(JoinWords(PrintWords)); //uses method signature for array input

            Console.ReadLine();
        }

        private static void PrintStuff(string text)
        {
            Console.WriteLine(text);
        }

        private static string JoinWords(string word1, string word2)//two string joiner
        {
            return (word1 + " " + word2);
        }

        private static string JoinWords(string[] words)//array string joiner
        {
            string newstring = "";
            foreach (string word in words)
            {
                newstring += word + " ";
            }
            return newstring;
        }
    }
}
```
