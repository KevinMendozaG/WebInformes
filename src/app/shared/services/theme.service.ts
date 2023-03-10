import { Injectable } from '@angular/core';

@Injectable({
  providedIn: 'root'
})
export class ThemeService {

  constructor() { }

  initializeTheme() {
    document.body.classList.toggle(this.getLocalStorageTheme());
  }

  private getLocalStorageTheme(): string {
    return localStorage.getItem('theme') || 'light-theme';
  }

  isDarkMode(): boolean {
    return document.body.classList.contains('dark-theme');
    // return localStorage.getItem('theme') == 'dark-theme';
  }

  toggleTheme() {
    var isDarkMode = this.isDarkMode();
    var themeRemove = isDarkMode ? 'dark-theme' : 'light-theme';
    var themeApply = isDarkMode ? 'light-theme' : 'dark-theme';

    document.body.classList.toggle(themeRemove);
    document.body.classList.toggle(themeApply);

    localStorage.setItem('theme', themeApply);
  }

  // private renderer: Renderer2;
  // private colorTheme: string = 'light-theme';
  // public themeSelected = new Subject<string>();

  // constructor(rendererFactory: RendererFactory2) {
  //   this.renderer = rendererFactory.createRenderer(null, null);
  //  }

  // watchColorTheme(): Observable<any> {
  //   return this.themeSelected.asObservable();
  // }

  // initializeTheme() {
  //   this.getColorTheme();
  //   this.renderer.addClass(document.body, this.colorTheme);
  // }

  // updateColorTheme(theme: 'dark-theme' | 'light-theme') {
  //   this.setColorTheme(theme);
  //   const previuosTheme = (theme === 'light-theme' ? 'dark-theme' : 'light-theme');
  //   this.renderer.removeClass(document.body, previuosTheme);
  //   this.renderer.addClass(document.body, theme);
  // }

  // isDarkMode(): boolean {
  //   return this.getColorTheme() === 'dark-theme';
  // }

  // private setColorTheme(theme: string) {
  //   this.colorTheme = theme;
  //   localStorage.setItem('color-theme', theme);
  //   this.themeSelected.next(theme);
  // }

  // getColorTheme() {
  //   if (localStorage.getItem('color-theme') === null) {
  //     this.setColorTheme('light-theme');
  //     return 'light-theme';
  //   }else {
  //     return localStorage.getItem('color-theme');
  //   }
  // }
}
