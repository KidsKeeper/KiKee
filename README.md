# KidsKeeper

## 업데이트2 (2020.07.21)
```
새로운 업데이트입니다.
설이가 수정한 파일을 master에 합쳤습니다.
android/src/main/manifest..어쩌구 이놈의 key값이 ****로 변경되었으며
ios/Runner/어쩌구dele어쩌구(?) 이놈의 key값도 ****로 변경되어
master 코드를 pull 하신경우 이 두 부분을 각각 google map key값으로 수정한뒤 실행해야 합니다.
```



```
다들 현재 합쳐진 파일로 업데이트를 하기위해


본인 작업 브랜치에서 `git pull origin master`를 해주시기 바랍니다!

만약 충돌로 인해 `aborting`이 난 경우 해결 방안은 두 가지 입니다.
```


> (만약 딱히 충돌도 안났는데 업데이트도 안됐다 하면... git fetch origin 한번 해보십숑)



### 1. 기존 파일에서 `stash`를 생성해 `stash` 저장을 해준 후 `master`파일을 받아오기

(Android stuido 에서는 VCS -> Git -> stash 있고

Visual studio Code 에서는 SOURCE CONTROL:GIT (왼쪽 세로형 메뉴바 3번째꺼)에서 ''' 누르고 밑에 stash 있음)


> 이렇게 하면 기존에 있던 파일은 `stash`파일에 저장됩니다. 하지만 `unstash`했을 때 충돌나는건 여전하겠죠. (vs code는 apply stash)

> > 그냥 기존 파일 쓸 생각 없단 마음으로 하는 방안입니다.
> > 주로 제가 새로운 브랜치 만들기 귀찮은데 충돌 해결을 직접하고 싶진 않다 싶을 때 사용하는 방법입니다.





### 2. 새로운 브랜치를 만든 후 위 방법 사용하기.

> 이렇게 하면 기존에 있던 브랜치의 파일들은 보존할 수 있습니다. 하지만 어차피 깃허브에 히스토리에 다 보존이 되어있는데 .. (생략)




#### ▶︎ 파일을 pull받고 실행시켜보기전에 `safeway_direction/lib/` 에 `keys.dart` 파일을 만들어야 합니다.


```dart
class Keys{
  static const String googleMap =  "******";
  static const String database = "******";
  static const String tMap = "******";
  static const String place = "******";
}
```



> 근데 여기서 googleMap이랑 place랑 키가 같은 경우 그냥 googleMap 키랑 place키에 값을 같은걸 넣어주면 됩니다.


(나중에 정리합시다ㅋㅋ)
