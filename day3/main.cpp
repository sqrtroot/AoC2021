#include <string_view>
#include <string>
#include <vector>
#include <bitset>
#include <array>
#include <span>
#include <fmt/core.h>
#include <algorithm>
#include <numeric>
#include <charconv>
#include <fstream>

template<typename T>
auto p1(const T& input){
    typename T::value_type count;
    for(int i = 0; i < count.size(); i++){
        int f = 0;
        for(const auto& e : input){
            if(e.test(i)){
                f++;
            };
        }
        if(f >= ((float)input.size())/2){
            count.set(i);
        }
    };
    return count;
}

template<typename T>
auto p2(const T& input, bool invert){
    std::vector<typename T::value_type> set(input.begin(), input.end());
    for(int i = set[0].size()-1; i >= 0 && set.size() > 1; i--){
        auto v1 = p1(set);
        set.erase(std::remove_if(set.begin(), set.end(), [&](auto& e){
            return invert != (v1.test(i) != e.test(i));
        }),set.end());
    }
    return set[0];
}

template<size_t T>
std::vector<std::bitset<T>> parse(const std::string& filename){
  std::vector<std::bitset<T>> output;
  std::ifstream testinput_f(filename.c_str());
  std::string x;
  while(std::getline(testinput_f, x)){
    std::bitset<T> t;
    for(size_t i = 0; i < T; i++){
      if(x[i]=='1') t.set(T-i-1);
    }
    output.push_back(t);
  }
  return output;
}

int main(){
  auto testinput = parse<5>("./testinput");
  fmt::print("testinput:");
  for(const auto& e : testinput){
    fmt::print("0b{}\n", e.to_string());
  }
  auto p1_t = p1(testinput);

  fmt::print("testinput p1:0b{} * 0b{}= {}, p2: {}\n",p1_t.to_string(), (~p1_t).to_string(), p1_t.to_ulong()*(~p1_t).to_ulong(),p2(testinput,false).to_ulong()*p2(testinput,true).to_ulong());
  auto input = parse<12>("./input");
  auto p1_f = p1(input);

  fmt::print("input p1:0b{} * 0b{}= {}, p2: {}\n",p1_f.to_string(), (~p1_f).to_string(), p1_f.to_ulong()*(~p1_f).to_ulong(),p2(input,false).to_ulong()*p2(input,true).to_ulong());
}
