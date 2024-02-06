import SwiftUI

struct StudentRegisterView: View {
  var body: some View {
    ZStack() {
      Group {
        Rectangle()
          .foregroundColor(.clear)
          .frame(width: 348, height: 539)
          .background(Color(red: 0.92, green: 0.90, blue: 0.97))
          .offset(x: 0, y: 45.50)
          .shadow(
            color: Color(red: 0, green: 0, blue: 0, opacity: 0.25), radius: 4, y: 4
          )
        ZStack() {
          Rectangle()
            .foregroundColor(.clear)
            .frame(width: 219, height: 32.15)
            .background(Color(red: 0.96, green: 0.96, blue: 0.96))
            .cornerRadius(12)
            .overlay(
              RoundedRectangle(cornerRadius: 12)
                .inset(by: 0.50)
                .stroke(Color(red: 0.50, green: 0.50, blue: 0.50), lineWidth: 0.50)
            )
            .offset(x: 0, y: 0)
            .shadow(
              color: Color(red: 0, green: 0, blue: 0, opacity: 0.12), radius: 2, y: 2
            )
          Text("Re-enter Password")
            .font(Font.custom("Outfit", size: 14))
            .foregroundColor(Color(red: 0.43, green: 0.43, blue: 0.43))
            .offset(x: 0, y: 1.10)
        }
        .frame(width: 219, height: 32.15)
        .offset(x: -1.50, y: 2.08)
        Text("Register Account ")
          .font(Font.custom("Raleway", size: 20).weight(.bold))
          .foregroundColor(.black)
          .offset(x: -12.50, y: -142)
        HStack(spacing: 0) {
          ZStack() { }
          .frame(width: 20, height: 19)
        }
        .frame(width: 20, height: 19)
        .offset(x: 45, y: -141.50)
        HStack(alignment: .top, spacing: 111.15) {
          HStack(spacing: 0) {
            Text("9:41")
              .font(Font.custom("Outfit", size: 17).weight(.ultraLight))
              .lineSpacing(22)
              .foregroundColor(.black)
          }
          .padding(
            EdgeInsets(top: 18.34, leading: 0, bottom: 13.66, trailing: 0)
          )
          .frame(height: 54)
          ZStack() {
            ZStack() {
              Rectangle()
                .foregroundColor(.clear)
                .frame(width: 25, height: 13)
                .cornerRadius(4.30)
                .overlay(
                  RoundedRectangle(cornerRadius: 4.30)
                    .inset(by: 0.50)
                    .stroke(.black, lineWidth: 0.50)
                )
                .offset(x: -1.16, y: 0)
                .opacity(0.35)
              Rectangle()
                .foregroundColor(.clear)
                .frame(width: 21, height: 9)
                .background(.black)
                .cornerRadius(2.50)
                .offset(x: -1.16, y: 0)
            }
            .frame(width: 27.33, height: 13)
          }
          .frame(width: 139.43, height: 54)
        }
        .frame(width: 390, height: 54)
        .cornerRadius(15)
        .overlay(
          RoundedRectangle(cornerRadius: 15)
            .stroke(.black, lineWidth: 0.50)
        )
        .offset(x: 0, y: -395)
        .shadow(
          color: Color(red: 0, green: 0, blue: 0, opacity: 0.25), radius: 4, y: 4
        )
        HStack(spacing: 0) {
          Rectangle()
            .foregroundColor(.clear)
            .frame(width: 139, height: 5)
            .background(Color(red: 0.95, green: 0.95, blue: 0.97))
            .cornerRadius(100)
            .rotationEffect(.degrees(-180))
        }
        .padding(EdgeInsets(top: 0, leading: 127, bottom: 0, trailing: 127))
        .frame(width: 393, height: 21)
        .offset(x: 1.50, y: 411.50)
        .opacity(0.75)
        ZStack() {
          Rectangle()
            .foregroundColor(.clear)
            .frame(width: 218, height: 45)
            .background(Color(red: 0.10, green: 0, blue: 0.32))
            .cornerRadius(12)
            .offset(x: 0, y: 0)
          Text("Register")
            .font(Font.custom("Outfit", size: 18).weight(.semibold))
            .foregroundColor(.white)
            .offset(x: 0, y: 0)
        }
        .frame(width: 218, height: 45)
        .offset(x: -1, y: 252.50)
        ZStack() {
          Rectangle()
            .foregroundColor(.clear)
            .frame(width: 219, height: 32.15)
            .background(Color(red: 0.96, green: 0.96, blue: 0.96))
            .cornerRadius(12)
            .overlay(
              RoundedRectangle(cornerRadius: 12)
                .inset(by: 0.50)
                .stroke(Color(red: 0.50, green: 0.50, blue: 0.50), lineWidth: 0.50)
            )
            .offset(x: 0, y: 0)
            .shadow(
              color: Color(red: 0, green: 0, blue: 0, opacity: 0.12), radius: 2, y: 2
            )
          Text("Student ID")
            .font(Font.custom("Outfit", size: 14))
            .foregroundColor(Color(red: 0.43, green: 0.43, blue: 0.43))
            .offset(x: -0.35, y: 0.43)
        }
        .frame(width: 219, height: 32.15)
        .offset(x: 0.50, y: -79.93)
        ZStack() {
          Rectangle()
            .foregroundColor(.clear)
            .frame(width: 219, height: 32.15)
            .background(Color(red: 0.96, green: 0.96, blue: 0.96))
            .cornerRadius(12)
            .overlay(
              RoundedRectangle(cornerRadius: 12)
                .inset(by: 0.50)
                .stroke(Color(red: 0.50, green: 0.50, blue: 0.50), lineWidth: 0.50)
            )
            .offset(x: 0, y: 0)
            .shadow(
              color: Color(red: 0, green: 0, blue: 0, opacity: 0.12), radius: 2, y: 2
            )
          Text("Year")
            .font(Font.custom("Outfit", size: 14))
            .foregroundColor(Color(red: 0.43, green: 0.43, blue: 0.43))
            .offset(x: -0.35, y: 0.43)
        }
        .frame(width: 219, height: 32.15)
        .offset(x: 0.50, y: 159.07)
        ZStack() {
          Rectangle()
            .foregroundColor(.clear)
            .frame(width: 219, height: 32.15)
            .background(Color(red: 0.96, green: 0.96, blue: 0.96))
            .cornerRadius(12)
            .overlay(
              RoundedRectangle(cornerRadius: 12)
                .inset(by: 0.50)
                .stroke(Color(red: 0.50, green: 0.50, blue: 0.50), lineWidth: 0.50)
            )
            .offset(x: 0, y: 0)
            .shadow(
              color: Color(red: 0, green: 0, blue: 0, opacity: 0.12), radius: 2, y: 2
            )
          Text("Course")
            .font(Font.custom("Outfit", size: 14))
            .foregroundColor(Color(red: 0.43, green: 0.43, blue: 0.43))
            .offset(x: -0.35, y: 0.43)
        }
        .frame(width: 219, height: 32.15)
        .offset(x: -0.50, y: 200.07)
      };Group {
        ZStack() {
          Rectangle()
            .foregroundColor(.clear)
            .frame(width: 219, height: 32.15)
            .background(Color(red: 0.96, green: 0.96, blue: 0.96))
            .cornerRadius(12)
            .overlay(
              RoundedRectangle(cornerRadius: 12)
                .inset(by: 0.50)
                .stroke(Color(red: 0.50, green: 0.50, blue: 0.50), lineWidth: 0.50)
            )
            .offset(x: 0, y: 0)
            .shadow(
              color: Color(red: 0, green: 0, blue: 0, opacity: 0.12), radius: 2, y: 2
            )
          Text("Password")
            .font(Font.custom("Outfit", size: 14))
            .foregroundColor(Color(red: 0.43, green: 0.43, blue: 0.43))
            .offset(x: 0, y: 1.10)
        }
        .frame(width: 219, height: 32.15)
        .offset(x: -0.50, y: -38.92)
        ZStack() {
          Ellipse()
            .foregroundColor(.clear)
            .frame(width: 31, height: 6)
            .background(.white)
            .offset(x: -18, y: -40.50)
          Ellipse()
            .foregroundColor(.clear)
            .frame(width: 31, height: 6)
            .background(.white)
            .offset(x: 19, y: -40.50)
          Rectangle()
            .foregroundColor(.clear)
            .frame(width: 76, height: 74)
            .background(.white)
            .offset(x: 0.50, y: -4.50)
        }
        .frame(width: 95, height: 87)
        .offset(x: 0.50, y: -222.50)
        ZStack() {
          Rectangle()
            .foregroundColor(.clear)
            .frame(width: 219, height: 32.15)
            .background(Color(red: 0.96, green: 0.96, blue: 0.96))
            .cornerRadius(12)
            .overlay(
              RoundedRectangle(cornerRadius: 12)
                .inset(by: 0.50)
                .stroke(Color(red: 0.50, green: 0.50, blue: 0.50), lineWidth: 0.50)
            )
            .offset(x: 0, y: 0)
            .shadow(
              color: Color(red: 0, green: 0, blue: 0, opacity: 0.12), radius: 2, y: 2
            )
          Text("Name")
            .font(Font.custom("Outfit", size: 14))
            .foregroundColor(Color(red: 0.43, green: 0.43, blue: 0.43))
            .offset(x: -0.35, y: 0.43)
        }
        .frame(width: 219, height: 32.15)
        .offset(x: 0.50, y: 77.07)
        ZStack() {
          Rectangle()
            .foregroundColor(.clear)
            .frame(width: 219, height: 32.15)
            .background(Color(red: 0.96, green: 0.96, blue: 0.96))
            .cornerRadius(12)
            .overlay(
              RoundedRectangle(cornerRadius: 12)
                .inset(by: 0.50)
                .stroke(Color(red: 0.50, green: 0.50, blue: 0.50), lineWidth: 0.50)
            )
            .offset(x: 0, y: 0)
            .shadow(
              color: Color(red: 0, green: 0, blue: 0, opacity: 0.12), radius: 2, y: 2
            )
          Text("Email Address")
            .font(Font.custom("Outfit", size: 14))
            .foregroundColor(Color(red: 0.43, green: 0.43, blue: 0.43))
            .offset(x: -0.35, y: 0.43)
        }
        .frame(width: 219, height: 32.15)
        .offset(x: 0.50, y: 118.07)
        Text("Password should be 8 minimum characters, at least 1 number, 1 special character, 1 Caps Lock ")
          .font(Font.custom("Outfit", size: 10).weight(.light))
          .foregroundColor(Color(red: 0.26, green: 0.52, blue: 0.96))
          .offset(x: 0, y: 40)
      }
    }
    .frame(width: 390, height: 844)
    .background(.white);
  }
}

struct StudentRegisterView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
