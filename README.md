# desktop-laptop-migration

Once you run the script, it should give you 3 options which are all self-explanatory. 

![image](https://user-images.githubusercontent.com/59761801/115500097-40796a80-a2a3-11eb-9e55-24e396ae011e.png)



Pre-requisites:

1. The laptop should be imaged, on the domain and has a network
2. You should log in to the laptop as a domain admin as most of the commands here require you to be an admin to run. You can use your own account if it makes it easier.
3. The remote computer should be turned on and on the network

Definition of options available: 

**Option 1. Get All Installed Software**

This option gets you the installed applications on the remote computer.

After selecting option 1 from the previous menu, you should get this screen:

![image](https://user-images.githubusercontent.com/59761801/115505228-b08bee80-a2ab-11eb-84ec-4203f683b472.png)

Once the computer name is confirmed, a grid-view of all the listed software should pop-up. Like so: 

![image](https://user-images.githubusercontent.com/59761801/115505260-bd104700-a2ab-11eb-9e1d-25c772eb3254.png)

You can now install these applications. The list makes the migration easier.


**Option 2. Get All Mapped Drives**

This option gets you the mapped drives on the remove computer, from the user profile you selected. 

After selecting option 2 from the previous menu, you should get this screen:

![image](https://user-images.githubusercontent.com/59761801/115505415-0365a600-a2ac-11eb-9d99-8ec0dce8b23b.png)

Once you have confirmed the computer name and the username (take note: the username has to be the same as the user’s Active Directory UPN.  It’s usually f.lastname for INSEAD), the script will get the path the and letter:

![image](https://user-images.githubusercontent.com/59761801/115505472-1b3d2a00-a2ac-11eb-8593-4806b4ff6f9d.png)

A couple of caveats: 

1. Enter the username/computer name correctly
2. Open the script as an admin so the script has the right to query registry entries (this is where it will get the correct shared drive path)

You can now copy this and map it later once the user logs in.


**Option 3. Copy User’s Profile**

This option copies a user profile from a remote computer to local (where the script is being run).

After selecting option 3 from the previous menu, you should get this screen:

![image](https://user-images.githubusercontent.com/59761801/115505528-2d1ecd00-a2ac-11eb-8f11-3a755f06333d.png)

Once you have confirmed the computer name and the username (take note: the username has to be the same as the user’s Active Directory UPN. It’s usually f.lastname for INSEAD), the script will copy the profile to the local computer (where the script is being run).

![image](https://user-images.githubusercontent.com/59761801/115506249-3c524a80-a2ad-11eb-86fa-da91c37039fc.png)

This copies the following folder:

*Desktop<br>
Downloads<br>
Favorites<br>
Documents<br>
Pictures<br>
Videos<br>
Appdata\Local\Google<br>*

A couple of caveats:

1.Enter the username/computer name correctly<br>
2. Open the script as an admin.<br>
3. The remote computer should be turned in and on the network

