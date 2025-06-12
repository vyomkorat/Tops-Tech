import random
import smtplib
import json
import os

class ATM:
    def __init__(self):
        self.data_file = 'atm_data.json'
        self.pin = self.get_pin()
        self.balance = self.get_balance()
        self.email = self.get_email()
        self.language = self.choose_language()

    def choose_language(self):
        choice = input("""
            Press 1 -> English
            Press 2 -> ગુજરાતી

            Enter your choice: """)
        return 'gu' if choice == '2' else 'en'

    def translate(self, en_text, gu_text):
        return gu_text if self.language == 'gu' else en_text

    def send_email(self, subject, body):
        sender_email = "vyomkorat3@gmail.com"
        sender_password = "zkjy vbbk dzmc mpry"
        recipient_email = self.email
        try:
            with smtplib.SMTP("smtp.gmail.com", 587) as server:
                server.starttls()
                server.login(sender_email, sender_password)
                message = f"Subject: {subject}\n\n{body}"
                server.sendmail(sender_email, recipient_email, message)
            print(self.translate("Email sent successfully!", "ઈમેઇલ સફળતાપૂર્વક મોકલવામાં આવ્યો!"))
        except Exception as e:
            print(self.translate(f"Error sending email: {e}", f"ઈમેઇલ મોકલવામાં ભૂલ: {e}"))

    def menu(self):
        user_input = input(self.translate("""
            Press 1 -> Create Pin
            Press 2 -> Change Pin
            Press 3 -> Deposit Money
            Press 4 -> Check Balance
            Press 5 -> Withdraw Money
            Press 6 -> Exit

            Enter Your Choice: """,
            """
            દબાવો 1 -> પિન બનાવો
            દબાવો 2 -> પિન બદલો
            દબાવો 3 -> પૈસા જમા કરો
            દબાવો 4 -> બેલેન્સ તપાસો
            દબાવો 5 -> પૈસા ઉપાડો
            દબાવો 6 -> બહાર નીકળો

            તમારું પસંદગી દાખલ કરો: """))

        if user_input == '1':
            self.create_pin()
        elif user_input == '2':
            self.change_pin()
        elif user_input == '3':
            self.deposit()
        elif user_input == '4':
            self.check_balance()
        elif user_input == '5':
            self.withdraw()
        else:
            exit()

    def create_pin(self):
        email = input(self.translate("Enter your Email for Verification: ", "તમારા ઈમેઇલની પુષ્ટિ માટે દાખલ કરો: "))
        self.email = email
        self.save_data()
        otp = self.generate_otp(6)
        self.send_otp(otp, email)
        user_otp = input(self.translate("Enter the OTP: ", "OTP દાખલ કરો: "))

        if user_otp == otp:
            print(self.translate("OTP Verified", "OTP ચકાસાયેલ"))
            if not self.pin:
                user_pin = input(self.translate("Create your Pin: ", "તમારું પિન બનાવો: "))
                self.pin = user_pin
                self.save_data()
                print(self.translate("Pin Created Successfully", "પિન સફળતાપૂર્વક બનાવાયું"))
        else:
            print(self.translate("Invalid OTP", "અમાન્ય OTP"))
        self.menu()

    def change_pin(self):
        old_pin = input("Enter your old pin : ")
        if old_pin == self.pin:
            new_pin = input("Enter your new pin : ")
            if old_pin != new_pin:
                self.pin = new_pin
                self.save_data()
                print("Pin Changed Successfully")
            else:
                print("Your Old pin and New pin are the same.")
        else:
            print("Old Pin is Incorrect.")
        self.menu()

    def deposit(self):
        deposit_pin = input(self.translate("Enter the Pin: ", "પિન દાખલ કરો: "))
        if deposit_pin == self.pin:
            amount = int(input(self.translate('Enter the Amount to Deposit: ', 'જમા કરવાની રકમ દાખલ કરો: ')))
            self.balance += amount
            self.save_data()
            self.send_email("Deposit Notification", f"Your account has been credited with INR {amount}. Current balance: INR {self.balance}.")
            print(self.translate("Your Money has been Deposited Successfully.", "તમારા પૈસા સફળતાપૂર્વક જમા થઈ ગયા છે."))
        else:
            print(self.translate("Your Pin is Incorrect.", "તમારો પિન ખોટો છે."))
        self.menu()

    def withdraw(self):
        withdraw_pin = input(self.translate("Enter the Pin: ", "પિન દાખલ કરો: "))
        if withdraw_pin == self.pin:
            amount = int(input(self.translate('Enter the Withdrawal Amount: ', 'ઉપાડ રકમ દાખલ કરો: ')))
            if amount > self.balance:
                print(self.translate("Insufficient Balance.", "અપૂરતું બેલેન્સ."))
            else:
                self.balance -= amount
                self.save_data()
                self.send_email("Withdrawal Notification", f"Your account has been debited with INR {amount}. Current balance: INR {self.balance}.")
                print(self.translate(f"Your Balance is now {self.balance}.", f"તમારું બેલેન્સ હવે છે {self.balance}"))
        else:
            print(self.translate("Your Pin is Incorrect.", "તમારો પિન ખોટો છે."))
        self.menu()
    
    def check_balance(self):
        bal_pin = input("Enter the Pin : ")
        if bal_pin == self.pin:
            print(f"Your Current Balance is {self.get_balance()}")
        else:
            print("Your Pin is Incorrect.")
        self.menu()

    def generate_otp(self, length=6):
        return ''.join([str(random.randint(0, 9)) for _ in range(length)])

    def send_otp(self, otp, recipient_email):
        sender_email = "vyomkorat3@gmail.com"
        sender_password = "zkjy vbbk dzmc mpry"
        subject = "Your OTP Code"
        body = f"Your OTP is: {otp}"
        try:
            with smtplib.SMTP("smtp.gmail.com", 587) as server:
                server.starttls()
                server.login(sender_email, sender_password)
                message = f"Subject: {subject}\n\n{body}"
                server.sendmail(sender_email, recipient_email, message)
            print("OTP sent successfully!")
        except Exception as e:
            print(f"Error sending OTP: {e}")

    def send_notification(self, transaction_type, amount):
        sender_email = "vyomkorat3.com"
        sender_password = "zkjy vbbk dzmc mpry"
        subject = f"{transaction_type} Notification"
        body = f"Your account has been {transaction_type.lower()}ed with INR {amount}. Current balance: INR {self.balance}."
        try:
            with smtplib.SMTP("smtp.gmail.com", 587) as server:
                server.starttls()
                server.login(sender_email, sender_password)
                message = f"Subject: {subject}\n\n{body}"
                server.sendmail(sender_email, self.email, message)
            print(f"{transaction_type} notification sent successfully!")
        except Exception as e:
            print(f"Error sending {transaction_type} notification: {e}")


    def get_pin(self):
        if os.path.exists(self.data_file):
            with open(self.data_file, "r") as file:
                data = json.load(file)
                return data.get("pin", '')
        return ''

    def get_balance(self):
        if os.path.exists(self.data_file):
            with open(self.data_file, "r") as file:
                data = json.load(file)
                return data.get("balance", 0)
        return 0

    def get_email(self):
        if os.path.exists(self.data_file):
            with open(self.data_file, "r") as file:
                data = json.load(file)
                return data.get("email", '')
        return ''

    def load_data(self):
        if os.path.exists(self.data_file):
            with open(self.data_file, "r") as file:
                return json.load(file)
        return {}

    def save_data(self):
        with open(self.data_file, "w") as file:
            json.dump({"pin": self.pin, "balance": self.balance, "email": self.email}, file)

user = ATM()
user.menu()
