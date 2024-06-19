class UserDto {
  constructor(user, token) {
    this.token = token;
    this.username = user.username;
    this.avatar = user.avatar_path;
  }
}

module.exports = UserDto;
